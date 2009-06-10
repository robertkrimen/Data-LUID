package Data::LUID::Table;

use Moose;
use Data::LUID::Carp;

use BerkeleyDB qw/DB_NOTFOUND/;
use Path::Class;

has path => qw/is ro lazy_build 1/;
sub _build_path {
    return './luid';
}

has bdb_manager => qw/is ro lazy_build 1/;
sub _build_bdb_manager {
    require BerkeleyDB::Manager;
    my $self = shift;
    my $home = dir $self->path;
    $home->mkpath unless -d $home;
    return BerkeleyDB::Manager->new( home => $home, create => 1 );
}

sub bdb_table {
    my $self = shift;
    return $self->bdb_manager->open_db( 'table', class => 'BerkeleyDB::Hash' );
}

sub store {
    my $self = shift;
    my $key = shift;
    my $value = shift || 1;

    my $status = $self->bdb_table->db_put( $key, $value );
    croak "Problem storing \"$key\" => \"$value\": $status" if $status;
    return $value;
}

sub exists {
    my $self = shift;
    my $key = shift;

    my $value;

    my $status = $self->bdb_table->db_get( $key, $value );
    return 0 if $status == DB_NOTFOUND;
    return 1 unless $status;
    croak "Problem checking existence of \"$key\": $status";
}

sub delete {
    my $self = shift;
    my $key = shift;

    my $status = $self->bdb_table->db_del( $key );
    return if $status == DB_NOTFOUND;
    croak "Problem deleting \"$key\": $status" if $status;
}

1;
