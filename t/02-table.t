#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use Data::LUID::Table;
use Directory::Scratch;

my $scratch = Directory::Scratch->new;
my ($table);

$table = Data::LUID::Table->new( path => $scratch->dir( 'luid' ) );

ok( ! $table->exists( 'apple' ) );
$table->store( 'apple' => 1 );
ok( $table->exists( 'apple' ) );

undef $table;
$table = Data::LUID::Table->new( path => $scratch->dir( 'luid' ) );

ok( $table->exists( 'apple' ) );
ok( ! $table->exists( 'banana' ) );
$table->store( 'banana' );
$table->delete( 'apple' );
ok( ! $table->exists( 'apple' ) );
ok( $table->exists( 'banana' ) );

1;
