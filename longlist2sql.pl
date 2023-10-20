#!/usr/bin/env perl

use JSON;
use FileHandle;
use Data::Dumper;

unlink glob "out/*.*";
open($list, '<', './longlist.json');
my @item  = <$list>;
close($list);

my $json     = JSON->new->allow_nonref;
my %longlist = %{$json->decode(join("", "@item"))};
my @keys     = keys(%longlist);

my %languages;
my %currencies;
my %continents;

my $languagesRef;
my $currenciesRef;
my $continentsRef;

my $languagesText         = "INSERT INTO languages (lg_id, lg_name)\nVALUES\n";
my $currenciesText        = "INSERT INTO currencies (cu_id, cu_name)\nVALUES\n";
my $continentsText        = "INSERT INTO continents (ct_id, ct_name)\nVALUES\n";
my $countriesText         = "INSERT INTO countries (co_id, co_continent_id, co_common_name, co_flag, co_tld, co_calling_codes, co_eu_member)\nVALUES\n";
my $countryLanguagesText  = "INSERT INTO country_languages (cl_country_id, cl_language_id)\nVALUES\n";
my $countryCurrenciesText = "INSERT INTO country_currencies (cc_country_id, cc_currency_id)\nVALUES\n";

my $start = 0;
for $key (sort @keys) {
    my $commonName   = quote($longlist{$key}->{name}->{common});
    my $flag         = $longlist{$key}->{extra}->{emoji};
    my $tld          = $longlist{$key}->{tld};
    my $callingCode  = $longlist{$key}->{dialling}->{calling_code};
    my $continent    = $longlist{$key}->{geo}->{continent};
    my $languages    = $longlist{$key}->{languages};
    my $currency     = $longlist{$key}->{currency};

    my @keysContinent = keys(%$continent);
    my $nameContinent = $keysContinent[0];

    my $euMember     = 'false';
    my $tldStr       = '';
    my $callStr      = '';

    $euMember        = 'true' if($longlist{$key}->{extra}->{eu_member});
    $tldStr          = substr $$tld[0], 1 if(ref $tld eq ref []);
    $callStr         = join(',', @$callingCode) if(ref $callingCode eq ref []);
    

    ($languagesRef, $countryLanguagesText) = printJoinTableText (
        $languages, 
        $countryLanguagesText,
        $start,
        $key,
        \%languages,
        sub {my ($key, $hash) = @_; $$hash{$key};}
    );
    %languages = %$languagesRef;

    ($currenciesRef, $countryCurrenciesText) = printJoinTableText (
        $currency,
        $countryCurrenciesText,
        $start,
        $key,
        \%currencies,
        sub {my ($key, $hash) = @_; $$hash{$key}->{iso_4217_name};}
    );
    %currencies = %$currenciesRef;

    ($continentsRef) = printJoinTableText (
        $continent,
        0,
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
    $countriesText .= "('$key', '$nameContinent', '$commonName', '$flag', '$tldStr', '$callStr', $euMember)";
}
$continentsText = printTableText($continentsText, \%continents);
$languagesText  = printTableText($languagesText , \%languages);
$currenciesText = printTableText($currenciesText , \%currencies);

open($outFile, '>', './out/i18n.sql');

print $outFile "$continentsText\n";
print $outFile "$countriesText;\n\n";
print $outFile "$languagesText\n";
print $outFile "$currenciesText\n";
print $outFile "$countryLanguagesText;\n\n";
print $outFile "$countryCurrenciesText;\n";

close($outFile);

sub printJoinTableText {
    my ($hash, $text, $start, $in, $out, $getVal) = @_;
    if(ref $hash eq ref {}) {
        my @keys = sort keys(%$hash);
        foreach $key (@keys) {
            $$out{$key} = &$getVal($key, $hash);
            if($text ne 0) {
                if($start > 0) {
                    $text .= ",\n";
                }
                $text .= "('$in', '$key')"  
            }
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
    $string =~ s/'/\\'/g;
    return $string;
}