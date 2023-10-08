#!/usr/bin/env perl

use JSON;
use Data::Dumper;

open($list, '<', './longlist.json');

my $i = 0;
my @item  = <$list>;

my $json = JSON->new->allow_nonref;
my %longlist = %{$json->decode(join("", "@item"))};
my @keys = keys(%longlist);

my %languages;
my %currencies;

open($countriesOut,         '>', './out/countries.sql');
open($countryLanguagesOut,  '>', './out/countrylanguages.sql');
open($countryCurrenciesOut, '>', './out/countrycurrencies.sql');

print $countriesOut         "INSERT INTO countries (id, common, official, flag)\nVALUES\n";
print $countryLanguagesOut  "INSERT INTO country_languages (country, language)\nVALUES\n";
print $countryCurrenciesOut "INSERT INTO country_currencies (id, name)\nVALUES\n";

my $start = 0;
for $key (sort @keys) {
    my $commonName   = quote($longlist{$key}->{name}->{common});
    my $officialName = quote($longlist{$key}->{name}->{official});
    my $flag         = $longlist{$key}->{extra}->{emoji};

    %languages = printHash (
        $longlist{$key}->{languages}, 
        $countryLanguagesOut,
        $start,
        $key,
        \%languages,
        sub {my ($key, $hash) = @_; $$hash{$key};}
    );

    %currencies = printHash (
        $longlist{$key}->{currency},
        $countryCurrenciesOut,
        $start,
        $key,
        \%currencies,
        sub {my ($key, $hash) = @_; $$hash{$key}->{iso_4217_name};}
    );

    if($start > 0){
        print $countriesOut ",\n";
    }
    $start = 1;
    print $countriesOut "('$key', '$commonName', '$officialName', '$flag')";
}
print $countriesOut ";\n";
print $countryLanguagesOut ";\n";
print $countryCurrenciesOut ";\n";


printTable(
    './out/languages.sql', 
    "INSERT INTO languages (id, name)\nVALUES\n", 
    \%languages
);


printTable(
    './out/currencies.sql', 
    "INSERT INTO currencies (id, name)\nVALUES\n", 
    \%currencies
);


close($countryCurrenciesOut);
close($countryLanguagesOut);
close($countriesOut);
close($list);

sub printHash {
    my ($hash, $fh, $start, $in, $out, $getVal) = @_;
    if(ref $hash eq ref {}) {
        my @keys = sort keys(%$hash);

        foreach $key (@keys) {
            $$out{$key} = &$getVal($key, $hash);

            if($start > 0) {
                print $fh ",\n";
            }
            print "key:$key in:$in\n";
            print $fh "('$key', '$in')"
        }
    }
    return %$out;
}

sub printTable {
    my ($filename, $insert, $hash) = @_;
    my @keys = sort keys(%$hash);
    my $start = 0;

    open($fh, '>', $filename);
    print $fh $insert;
    for $key (@keys) {
        my $name = quote($hash->{$key});
        if($start > 0) {
            print $fh ",\n";
        }
        $start = 1;
        print $fh "('$key', '$name')";
    }
    print $fh ";\n";
    close($fh);
}

sub quote {
    my ($string) = @_;
    $string =~ s/'/''/g;
    return $string;
}