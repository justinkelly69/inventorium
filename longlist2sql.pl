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
    'countries' => {
        file => './out/countries.sql',
        sql  => "INSERT INTO countries (id, common, official, flag, tld, callingCode, euMember)\nVALUES\n"
    },
    'country_languages' => {
        file => './out/country-languages.sql',
        sql  => "INSERT INTO country_languages (country, language)\nVALUES\n"
    },
    'country_currencies' => {
        file => './out/country-currencies.sql',
        sql  =>  "INSERT INTO country_currencies (id, name)\nVALUES\n"
    },
    'country_continents' => {
        file => './out/country-continents.sql',
        sql  => "INSERT INTO country_continents (id, name)\nVALUES\n"
    },
    'languages' => {
        file => './out/languages.sql', 
        sql  => "INSERT INTO languages (id, name)\nVALUES\n", 
    },
    'currencies' => {
        file => './out/currencies.sql',
        sql  => "INSERT INTO currencies (id, name)\nVALUES\n", 
    },
    'continents' => {
        file => './out/continents.sql',
        sql  =>"INSERT INTO continents (id, name)\nVALUES\n", 
    },
};

my $countriesOut          = printOpen($inserts->{'countries'});
my $countryLanguagesOut   = printOpen($inserts->{'country_languages'});
my $countryCurrenciesOut  = printOpen($inserts->{'country_currencies'});
my $countryContinentsOut  = printOpen($inserts->{'country_continents'});

my %languages;
my %currencies;
my %continents;

my $start = 0;
for $key (sort @keys) {
    my $commonName   = quote($longlist{$key}->{name}->{common});
    my $officialName = quote($longlist{$key}->{name}->{official});
    my $flag         = $longlist{$key}->{extra}->{emoji};
    my $tld          = $longlist{$key}->{tld};
    my $callingCode  = $longlist{$key}->{dialling}->{calling_code};
    my $continent    = $longlist{$key}->{geo}->{continent};
   
    my $euMember     = 'false';
    my $tldStr       = '';
    my $callStr      = '';

    $euMember        = 'true' if($longlist{$key}->{extra}->{eu_member});
    $tldStr          = substr $$tld[0], 1 if(ref $tld eq ref []);
    $callStr         = join(',', @$callingCode) if(ref $callingCode eq ref []);
    
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
    print $countriesOut "('$key', '$commonName', '$officialName', '$continent', '$flag', '$tldStr', '$callStr', $euMember)";
}

printClose($countriesOut);
printClose($countryLanguagesOut);
printClose($countryCurrenciesOut);
printClose($countryContinentsOut);

printTable($inserts->{'languages'} , \%languages);
printTable($inserts->{'currencies'}, \%currencies);
printTable($inserts->{'continents'}, \%continents);

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
    my ($args, $hash) = @_;
    my @keys = sort keys(%$hash);
    my $start = 0;
    my $fh = printOpen($args);
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
    my ($args) = @_;
    my $fh = new FileHandle(">$args->{file}");
    print $fh "$args->{sql}";
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