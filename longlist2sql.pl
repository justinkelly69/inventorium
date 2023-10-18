#!/usr/bin/env perl

use JSON;
use FileHandle;
use Data::Dumper;

unlink glob "out/*.*";

open($list, '<', './longlist.json');
my @item  = <$list>;
close($list);

my $json = JSON->new->allow_nonref;
my %longlist = %{$json->decode(join("", "@item"))};
my @keys = keys(%longlist);

my $inserts = {
    'countries'           => "INSERT INTO countries (co_id, co_continent_id, co_common_name, co_official_name, co_flag, co_tld, co_calling_codes, co_eu_member, co_enabled)\nVALUES\n",
    'country_languages'   => "INSERT INTO country_languages (cl_country_id, cl_language_id)\nVALUES\n",
    'country_currencies'  => "INSERT INTO country_currencies (cc_country_id, cc_currency_id)\nVALUES\n",
    'languages'           => "INSERT INTO languages (lg_id, lg_name)\nVALUES\n",
    'currencies'          => "INSERT INTO currencies (ct_id, ct_name)\nVALUES\n",
    'continents'          => "INSERT INTO continents (ct_id, ct_name)\nVALUES\n"
};

my %languages;
my $languagesText = $inserts->{'languages'};
my %currencies;
my $currenciesText = $inserts->{'currencies'};
my %continents;
my $continentsText = $inserts->{'continents'};
my $countriesText         = $inserts->{countries};
my $countryLanguagesText  = $inserts->{country_languages};
my $languagesRef;
my $countryCurrenciesText = $inserts->{country_currencies};
my $currenciesRef;
my $countryContinentsText = "";
my $continentsRef;

my $start = 0;
for $key (sort @keys) {
    my $commonName   = quote($longlist{$key}->{name}->{common});
    my $officialName = quote($longlist{$key}->{name}->{official});
    my $flag         = $longlist{$key}->{extra}->{emoji};
    my $tld          = $longlist{$key}->{tld};
    my $callingCode  = $longlist{$key}->{dialling}->{calling_code};
    my $continent    = $longlist{$key}->{geo}->{continent};

    my @keysContinent = keys(%$continent);
    my $nameContinent = $keysContinent[0];

    my $euMember     = 'false';
    my $tldStr       = '';
    my $callStr      = '';

    $euMember        = 'true' if($longlist{$key}->{extra}->{eu_member});
    $tldStr          = substr $$tld[0], 1 if(ref $tld eq ref []);
    $callStr         = join(',', @$callingCode) if(ref $callingCode eq ref []);
    

    ($languagesRef, $countryLanguagesText) = printJoinTableText (
        $longlist{$key}->{languages}, 
        $countryLanguagesText,
        $start,
        $key,
        \%languages,
        sub {my ($key, $hash) = @_; $$hash{$key};}
    );
    %languages = %$languagesRef;

    ($currenciesRef, $countryCurrenciesText) = printJoinTableText (
        $longlist{$key}->{currency},
        $countryCurrenciesText,
        $start,
        $key,
        \%currencies,
        sub {my ($key, $hash) = @_; $$hash{$key}->{iso_4217_name};}
    );
    %currencies = %$currenciesRef;

    ($continentsRef, $countryContinentsText) = printJoinTableText (
        $continent,
        $countryContinentsText,
        $start, 
        $key, 
        \%continents, 
        sub {my ($key, $hash) = @_; $$hash{$key};}
    );
    %continents = %$continentsRef;
    
    if($start > 0){
        $countriesText .= ",\n";
    }
    $start = 1;
    $countriesText .= "('$key', '$nameContinent', '$commonName', '$officialName', '$flag', '$tldStr', '$callStr', $euMember)";
}
$continentsText = printTableText($continentsText, \%continents);
$languagesText  = printTableText($languagesText , \%languages);
$currenciesText = printTableText($currenciesText , \%languages);

open($outFile, '>', './out/i18n.sql');

print $outFile "$continentsText\n";
print $outFile "$countriesText;\n";
print $outFile "$languagesText\n";
print $outFile "$currenciesText\n";
print $outFile "$countryLanguagesText;\n";
print $outFile "$countryCurrenciesText;\n";

close($outFile);

sub printJoinTableText {
    my ($hash, $text, $start, $in, $out, $getVal) = @_;
    if(ref $hash eq ref {}) {
        my @keys = sort keys(%$hash);
        foreach $key (@keys) {
            $$out{$key} = &$getVal($key, $hash);
            if($start > 0) {
                $text .= ",\n";
            }
            $text .= "('$in', '$key')"  
        }
    }
    return ($out, $text);
}

sub printTableText {
    my ($text, $hash) = @_;
    my @keys = sort keys(%$hash);
    my $start = 0;
    for $key (@keys) {
        my $name = quote($hash->{$key});
        if($start > 0) {
            $text .=  ",\n";
        }
        $start = 1;
        $text .=  "('$key', '$name')";
    }
    $text .= ";\n";
    return $text;
}

sub quote {
    my ($string) = @_;
    $string =~ s/'/''/g;
    return $string;
}