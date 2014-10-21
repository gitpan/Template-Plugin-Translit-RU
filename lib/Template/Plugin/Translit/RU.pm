#============================================================= -*-Perl-*-
#
# Template::Plugin::Translit::RU
#
# DESCRIPTION
#   Filter converting cyrillic text into transliterated one.
#
# AUTHOR
#   Igor Lobanov   <igor.lobanov@gmail.com>
#
# COPYRIGHT
#   Copyright (C) 2004 Igor Lobanov.  All Rights Reserved.
#
#   This module is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
#============================================================================

package Template::Plugin::Translit::RU;
use strict;
use vars qw( $VERSION );
use Template::Plugin;
use base qw( Template::Plugin );

$VERSION = sprintf("%d.%02d", q$Revision: 0.03 $ =~ /(\d+)\.(\d+)/);

# (en|de)code table
my $tab = {
	koi	=> {
		# {1} => {1}
		single	=> [
			'������������������������������������������������',
			"abvgdezijklmnoprstuf'y\"eABVGDEZIJKLMNOPRSTUF'Y\"E"
		],
		# +	=> {2,}
		plural	=> [
			# 0: re with plural-transliterated letters and special cases
			'(�[ţ��]|�|�|�|�|�|�|�|�|�|�[���]|�|�|�|�|�|�|�|�|�)',
			# 1: table for these letters and cases [0]
			{
				'�'		=> 'yo',
				'�'		=> 'Yo',
				'�'		=> 'zh',
				'�'		=> 'Zh',
				'�'		=> 'kh',
				'�'		=> 'Kh',
				'�'		=> 'tc',
				'�'		=> 'Tc',
				'�'		=> 'ch',
				'�'		=> 'Ch',
				'�'		=> 'sh',
				'�'		=> 'Sh',
				'�'		=> 'shch',
				'�'		=> 'Shch',
				'�'		=> 'yu',
				'�'		=> 'Yu',
				'�'		=> 'ya',
				'�'		=> 'Ya',
				# {2} => {2,3} - could not be at the begining of the word
				'��'	=> 'je',
				'��'	=> 'JE',
				'أ'	=> 'jio',
				'��'	=> 'JIO',
				'��'	=> 'ju',
				'��'	=> 'JU',
				'��'	=> 'ja',
				'��'	=> 'JA',
			},
			# 3: re with special transliterated escapes
			'(shch|Shch|SHCH|tch|TCH|Tch|je|jio|ju|ja|JE|JIO|JU|JA|yo|zh|kh|tc|ch|sh|yu|ya|Y[Oo]|Z[Hh]|K[Hh]|T[Cc]|C[Hh]|S[Hh]|Y[Uu]|Y[Aa])',
			# 4: table for special transliterated escapes [3]
			{
				'shch'	=> '�',
				'SHCH'	=> '�',
				'Shch'	=> '�',
				'tch'	=> '��',
				'TCH'	=> '��',
				'Tch'	=> '��',
				'je'	=> '��',
				'jio'	=> 'أ',
				'ju'	=> '��',
				'ja'	=> '��',
				'JE'	=> '��',
				'JIO'	=> '��',
				'JU'	=> '��',
				'JA'	=> '��',
				'yo'	=> '�',
				'zh'	=> '�',
				'kh'	=> '�',
				'tc'	=> '�',
				'ch'	=> '�',
				'sh'	=> '�',
				'yu'	=> '�',
				'ya'	=> '�',
				'YO'	=> '�',
				'Yo'	=> '�',
				'ZH'	=> '�',
				'Zh'	=> '�',
				'KH'	=> '�',
				'Kh'	=> '�',
				'TC'	=> '�',
				'Tc'	=> '�',
				'CH'	=> '�',
				'Ch'	=> '�',
				'SH'	=> '�',
				'Sh'	=> '�',
				'YU'	=> '�',
				'Yu'	=> '�',
				'YA'	=> '�',
				'Ya'	=> '�',
			}
		]
	},
	win	=> {
		# {1} => {1}
		single	=> [
			'������������������������������������������������',
			"abvgdezijklmnoprstuf'y\"eABVGDEZIJKLMNOPRSTUF'Y\"E"
		],
		# +	=> {2,}
		plural	=> [
			# 0: re with plural-transliterated letters and special cases
			'(�[���]|�|�|�|�|�|�|�|�|�|�[Ũ��]|�|�|�|�|�|�|�|�|�)',
			# 1: table for these letters and cases [0]
			{
				'�'		=> 'yo',
				'�'		=> 'Yo',
				'�'		=> 'zh',
				'�'		=> 'Zh',
				'�'		=> 'kh',
				'�'		=> 'Kh',
				'�'		=> 'tc',
				'�'		=> 'Tc',
				'�'		=> 'ch',
				'�'		=> 'Ch',
				'�'		=> 'sh',
				'�'		=> 'Sh',
				'�'		=> 'shch',
				'�'		=> 'Shch',
				'�'		=> 'yu',
				'�'		=> 'Yu',
				'�'		=> 'ya',
				'�'		=> 'Ya',
				# {2} => {2,3} - could not be at the begining of the word
				'��'	=> 'je',
				'��'	=> 'JE',
				'��'	=> 'jio',
				'ܨ'	=> 'JIO',
				'��'	=> 'ju',
				'��'	=> 'JU',
				'��'	=> 'ja',
				'��'	=> 'JA',
			},
			# 3: re with special transliterated escapes
			'(shch|Shch|SHCH|tch|TCH|Tch|je|jio|ju|ja|JE|JIO|JU|JA|yo|zh|kh|tc|ch|sh|yu|ya|Y[Oo]|Z[Hh]|K[Hh]|T[Cc]|C[Hh]|S[Hh]|Y[Uu]|Y[Aa])',
			# 4: table for special transliterated escapes [3]
			{
				'shch'	=> '�',
				'SHCH'	=> '�',
				'Shch'	=> '�',
				'tch'	=> '��',
				'TCH'	=> '��',
				'Tch'	=> '��',
				'je'	=> '��',
				'jio'	=> '��',
				'ju'	=> '��',
				'ja'	=> '��',
				'JE'	=> '��',
				'JIO'	=> 'ܨ',
				'JU'	=> '��',
				'JA'	=> '��',
				'yo'	=> '�',
				'zh'	=> '�',
				'kh'	=> '�',
				'tc'	=> '�',
				'ch'	=> '�',
				'sh'	=> '�',
				'yu'	=> '�',
				'ya'	=> '�',
				'YO'	=> '�',
				'Yo'	=> '�',
				'ZH'	=> '�',
				'Zh'	=> '�',
				'KH'	=> '�',
				'Kh'	=> '�',
				'TC'	=> '�',
				'Tc'	=> '�',
				'CH'	=> '�',
				'Ch'	=> '�',
				'SH'	=> '�',
				'Sh'	=> '�',
				'YU'	=> '�',
				'Yu'	=> '�',
				'YA'	=> '�',
				'Ya'	=> '�',
			}
		]
	}
};

# define aliases
$tab->{'windows-1251'} = $tab->{'cp1251'} = $tab->{'win'};
$tab->{'koi8-r'} = $tab->{'koi'};

my $DEFAULT_CHARSET = 'koi';

sub new {
	my ( $class, $context, @params ) = @_;

	# init future object
	my $self = {
		_CONTEXT	=> $context,
		_PARAMS		=> { map { $_ => 1 } @params },
	};

	# check translit flag and define translit filter factory
	if ( $self->{_PARAMS}->{translit} ) {
		$context->define_filter( 'translit', [ \&translit_filter_factory, 1 ] );
	}

	# check detranslit flag and define detranslit filter factory
	if ( $self->{_PARAMS}->{detranslit} ) {
		$context->define_filter( 'detranslit', [ \&detranslit_filter_factory, 1 ] );
	}

	bless $self, $class;
}

sub translit_filter_factory {
    my ( $context, $charset ) = @_;
    return sub {
		my $text = shift;
		Template::Plugin::Translit::RU->translit( $text, $charset );
    }
}

sub detranslit_filter_factory {
    my ( $context, $charset ) = @_;
    return sub {
		my $text = shift;
		Template::Plugin::Translit::RU->detranslit( $text, $charset );
    }
}

sub translit {
	my ( $self, $text, $charset ) = @_;
	$charset ||= $DEFAULT_CHARSET;
	# replace plurals (most slow place)
	$text =~ s/$tab->{$charset}->{plural}->[0]/$tab->{$charset}->{plural}->[1]->{$1}/sg;
	# replace singles
	eval "\$text =~ tr/$tab->{$charset}->{single}->[0]/$tab->{$charset}->{single}->[1]/";
	return $text;
}

sub detranslit {
	my ( $self, $text, $charset ) = @_;
	$charset ||= $DEFAULT_CHARSET;
	# replace plurals (most slow place)
	$text =~ s/$tab->{$charset}->{plural}->[2]/$tab->{$charset}->{plural}->[3]->{$1}/sge;
	# replace singles
	eval "\$text =~ tr/$tab->{$charset}->{single}->[1]/$tab->{$charset}->{single}->[0]/";
	return $text;
}

1;

__END__

=pod

=head1 NAME

Template::Plugin::Translit::RU - Filter converting cyrillic
text into transliterated one and back.

=head1 SYNOPSIS

 [%# Use as filters #%]
 [% USE Translit::RU 'translit' 'detranslit' %]
 [% FILTER translit( 'koi' ) %]
 ...
 This text would stay unchanged because it is not cyrillic.
 ...
 [% END %]

 [%#
    Use as object
    First argument - text for conversion
    Second optional argument - charset ('koi' is default)
 #%]
 [% USE translit = Translit::RU %]
 [% translit.translit( 'without cyrillic text is useless' ) %]
 [% translit.detranslit( 'kirilitca', 'win' ) %]

=head1 DESCRIPTION

Template::Plugin::Translit::RU is Template Toolkit filter which
allows to convert cyrillic text in one of two popular
charsets koi8-r and windows-1251 into transliterated latin
text. Also back conversion supported.

=head1 SUPPORTED CHARSETS

Currently Template::Plugin::Translit::RU supports 2 main
cyrillic charsets koi8-r and windows-1251.

=head1 IMPORTANT NOTE

This is alpha release of module. Charset tables and other
stuff could be changed in future versions. Use this module
on your own risk.

=head1 SEE ALSO

L<Template|Template>

=head1 AUTHOR

Igor Lobanov, E<lt>igor.lobanov@gmail.comE<gt>

=head1 COPYRIGHT

Copyright (C) 2004 Igor Lobanov. All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
