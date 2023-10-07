#!/usr/bin/env perl

open($list, '<', './longlist.json');
open($countriesOut, '>', './out/countries.sql');
open($languagesOut, '>', './out/languages.sql');
open($countryLanguagesOut, '>', './out/countrylanguages.sql');

print $countriesOut "INSERT INTO countries (id, common, official, flag)\n";
print $countryLanguagesOut "INSERT INTO country_languages (country, language)\n";
print $languagesOut "INSERT INTO languages (id, name)\n";

use JSON;
use Data::Dumper;

my $i = 0;
my @item  = <$list>;

my $json = JSON->new->allow_nonref;
my %longlist = %{$json->decode(join("", "@item"))};
my %languages;
my %currencies;

my $countriesStart = 0;
my $countryLanguagesStart = 0;
my $languagesStart = 0;

my @keys = keys(%longlist);
for $key (sort @keys) {
    my $commonName = quote($longlist{$key}->{name}->{common});
    my $officialName = quote($longlist{$key}->{name}->{official});
    my $flag = $longlist{$key}->{extra}->{emoji};

    my $langs = $longlist{$key}->{languages};

    if(ref $langs eq ref {}) {
        my @keys = keys(%$langs);
        my %langs = %$langs;
        foreach(@keys) {
            $languages{$_} = $langs{$_};
            if($countryLanguagesStart > 0){
                print $countryLanguagesOut ",\n";
            }
            $countryLanguagesStart = 1;
            print $countryLanguagesOut "('$key', '$_')";
        }
    }

    if($countriesStart > 0){
        print $countriesOut ",\n";
    }
    $countriesStart = 1;
    print $countriesOut "('$key', '$commonName', '$officialName', '$flag')";
}
print $countriesOut ";\n";
print $countryLanguagesOut ";\n";

my @langKeys = keys(%languages);
for(sort @langKeys) {
    my $language = quote($languages{$_});
    if($languagesStart > 0){
        print $languagesOut ",\n";
    }
    $languagesStart = 1;
    print $languagesOut "('$_', '$language')";
}
print $languagesOut ";\n";



close($countryLanguagesOut);
close($countriesOut);
close($languagesOut);
close($list);

sub quote {
    my ($string) = @_;
    $string =~ s/'/''/g;
    return $string;
}