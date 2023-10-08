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

my $countriesOut = printOpen (
    './out/countries.sql',
    "INSERT INTO countries (id, common, official, flag)\nVALUES\n"
);

my $countryLanguagesOut = printOpen (
    './out/countrylanguages.sql',
    "INSERT INTO country_languages (country, language)\nVALUES\n"
);

my $countryCurrenciesOut = printOpen (
    './out/countrycurrencies.sql',
    "INSERT INTO country_currencies (id, name)\nVALUES\n"
);

my $countryContinentsOut = printOpen (
    './out/countrycontinents.sql',
    "INSERT INTO country_continents (id, name)\nVALUES\n"
);

my %languages;
my %currencies;
my %continents;

my $start = 0;
for $key (sort @keys) {
    my $commonName   = quote($longlist{$key}->{name}->{common});
    my $officialName = quote($longlist{$key}->{name}->{official});
    my $flag         = $longlist{$key}->{extra}->{emoji};
    my $tld          = $longlist{$key}->{tld};
    print("@$tld\n");

    %languages = printJoinTable (
        $longlist{$key}->{languages}, 
        $countryLanguagesOut,
        $start,
        $key,
        \%languages,
        sub {my ($key, $hash) = @_; $$hash{$key};}
    );

    %currencies = printJoinTable (
        $longlist{$key}->{currency},
        $countryCurrenciesOut,
        $start,
        $key,
        \%currencies,
        sub {my ($key, $hash) = @_; $$hash{$key}->{iso_4217_name};}
    );

    %continents = printJoinTable (
        $longlist{$key}->{geo}->{continent}, 
        $countryContinentsOut,
        $start,
        $key,
        \%continents,
        sub {my ($key, $hash) = @_; $$hash{$key};}
    );

    if($start > 0){
        print $countriesOut ",\n";
    }
    $start = 1;
    print $countriesOut "('$key', '$commonName', '$officialName', '$flag')";
}

printClose($countriesOut);
printClose($countryLanguagesOut);
printClose($countryCurrenciesOut);
printClose($countryContinentsOut);

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

printTable(
    './out/continents.sql',
    "INSERT INTO continents (id, name)\nVALUES\n", 
    \%continents
);

sub printJoinTable {
    my ($hash, $fh, $start, $in, $out, $getVal) = @_;
    if(ref $hash eq ref {}) {
        my @keys = sort keys(%$hash);
        foreach $key (@keys) {
            $$out{$key} = &$getVal($key, $hash);
            if($start > 0) {
                print $fh ",\n";
            }
            print $fh "('$key', '$in')"
        }
    }
    return %$out;
}

sub printTable {
    my ($filename, $insert, $hash) = @_;
    my @keys = sort keys(%$hash);
    my $start = 0;
    my $fh = printOpen($filename, $insert);
    for $key (@keys) {
        my $name = quote($hash->{$key});
        if($start > 0) {
            print $fh ",\n";
        }
        $start = 1;
        print $fh "('$key', '$name')";
    }
    printClose($fh);
}

sub printOpen {
    my ($filename, $header) = @_;
    my $fh = new FileHandle(">$filename");
    print $fh $header;
    return $fh;
}

sub printClose {
    my ($fh) = @_;
    print $fh ";\n";
    close($fh);
}

sub quote {
    my ($string) = @_;
    $string =~ s/'/''/g;
    return $string;
}