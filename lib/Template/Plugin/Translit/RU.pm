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
			'ÁÂ×ÇÄÅÚÉÊËÌÍÎÏÐÒÓÔÕÆØÙßÜáâ÷çäåúéêëìíîïðòóôõæøùÿü',
			"abvgdezijklmnoprstuf'y\"eABVGDEZIJKLMNOPRSTUF'Y\"E"
		],
		# +	=> {2,}
		plural	=> [
			# 0: re with plural-transliterated letters and special cases
			'(Ø[Å£ÀÑ]|£|Ö|È|Ã|Þ|Û|Ý|À|Ñ|ø[å³àñ]|³|ö|è|ã|þ|û|ý|à|ñ)',
			# 1: table for these letters and cases [0]
			{
				'£'		=> 'yo',
				'³'		=> 'Yo',
				'Ö'		=> 'zh',
				'ö'		=> 'Zh',
				'È'		=> 'kh',
				'è'		=> 'Kh',
				'Ã'		=> 'tc',
				'ã'		=> 'Tc',
				'Þ'		=> 'ch',
				'þ'		=> 'Ch',
				'Û'		=> 'sh',
				'û'		=> 'Sh',
				'Ý'		=> 'shch',
				'ý'		=> 'Shch',
				'À'		=> 'yu',
				'à'		=> 'Yu',
				'Ñ'		=> 'ya',
				'ñ'		=> 'Ya',
				# {2} => {2,3} - could not be at the begining of the word
				'ØÅ'	=> 'je',
				'øå'	=> 'JE',
				'Ø£'	=> 'jio',
				'ø³'	=> 'JIO',
				'ØÀ'	=> 'ju',
				'øà'	=> 'JU',
				'ØÑ'	=> 'ja',
				'øñ'	=> 'JA',
			},
			# 3: re with special transliterated escapes
			'(shch|Shch|SHCH|tch|TCH|Tch|je|jio|ju|ja|JE|JIO|JU|JA|yo|zh|kh|tc|ch|sh|yu|ya|Y[Oo]|Z[Hh]|K[Hh]|T[Cc]|C[Hh]|S[Hh]|Y[Uu]|Y[Aa])',
			# 4: table for special transliterated escapes [3]
			{
				'shch'	=> 'Ý',
				'SHCH'	=> 'ý',
				'Shch'	=> 'ý',
				'tch'	=> 'ÔÞ',
				'TCH'	=> 'ôþ',
				'Tch'	=> 'ôÞ',
				'je'	=> 'ØÅ',
				'jio'	=> 'Ø£',
				'ju'	=> 'ØÀ',
				'ja'	=> 'ØÑ',
				'JE'	=> 'øå',
				'JIO'	=> 'ø³',
				'JU'	=> 'øà',
				'JA'	=> 'øñ',
				'yo'	=> '£',
				'zh'	=> 'Ö',
				'kh'	=> 'È',
				'tc'	=> 'Ã',
				'ch'	=> 'Þ',
				'sh'	=> 'Û',
				'yu'	=> 'À',
				'ya'	=> 'Ñ',
				'YO'	=> '³',
				'Yo'	=> '³',
				'ZH'	=> 'ö',
				'Zh'	=> 'ö',
				'KH'	=> 'è',
				'Kh'	=> 'è',
				'TC'	=> 'ã',
				'Tc'	=> 'ã',
				'CH'	=> 'þ',
				'Ch'	=> 'þ',
				'SH'	=> 'û',
				'Sh'	=> 'û',
				'YU'	=> 'à',
				'Yu'	=> 'à',
				'YA'	=> 'ñ',
				'Ya'	=> 'ñ',
			}
		]
	},
	win	=> {
		# {1} => {1}
		single	=> [
			'àáâãäåçèéêëìíîïðñòóôüûúýÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÜÛÚÝ',
			"abvgdezijklmnoprstuf'y\"eABVGDEZIJKLMNOPRSTUF'Y\"E"
		],
		# +	=> {2,}
		plural	=> [
			# 0: re with plural-transliterated letters and special cases
			'(ü[å¸þÿ]|¸|æ|õ|ö|÷|ø|ù|þ|ÿ|Ü[Å¨Þß]|¨|Æ|Õ|Ö|×|Ø|Ù|Þ|ß)',
			# 1: table for these letters and cases [0]
			{
				'¸'		=> 'yo',
				'¨'		=> 'Yo',
				'æ'		=> 'zh',
				'Æ'		=> 'Zh',
				'õ'		=> 'kh',
				'Õ'		=> 'Kh',
				'ö'		=> 'tc',
				'Ö'		=> 'Tc',
				'÷'		=> 'ch',
				'×'		=> 'Ch',
				'ø'		=> 'sh',
				'Ø'		=> 'Sh',
				'ù'		=> 'shch',
				'Ù'		=> 'Shch',
				'þ'		=> 'yu',
				'Þ'		=> 'Yu',
				'ÿ'		=> 'ya',
				'ß'		=> 'Ya',
				# {2} => {2,3} - could not be at the begining of the word
				'üå'	=> 'je',
				'ÜÅ'	=> 'JE',
				'ü¸'	=> 'jio',
				'Ü¨'	=> 'JIO',
				'üþ'	=> 'ju',
				'ÜÞ'	=> 'JU',
				'üÿ'	=> 'ja',
				'Üß'	=> 'JA',
			},
			# 3: re with special transliterated escapes
			'(shch|Shch|SHCH|tch|TCH|Tch|je|jio|ju|ja|JE|JIO|JU|JA|yo|zh|kh|tc|ch|sh|yu|ya|Y[Oo]|Z[Hh]|K[Hh]|T[Cc]|C[Hh]|S[Hh]|Y[Uu]|Y[Aa])',
			# 4: table for special transliterated escapes [3]
			{
				'shch'	=> 'ù',
				'SHCH'	=> 'Ù',
				'Shch'	=> 'Ù',
				'tch'	=> 'ò÷',
				'TCH'	=> 'Ò×',
				'Tch'	=> 'Ò÷',
				'je'	=> 'üå',
				'jio'	=> 'ü¸',
				'ju'	=> 'üþ',
				'ja'	=> 'üÿ',
				'JE'	=> 'ÜÅ',
				'JIO'	=> 'Ü¨',
				'JU'	=> 'ÜÞ',
				'JA'	=> 'Üß',
				'yo'	=> '¸',
				'zh'	=> 'æ',
				'kh'	=> 'õ',
				'tc'	=> 'ö',
				'ch'	=> '÷',
				'sh'	=> 'ø',
				'yu'	=> 'þ',
				'ya'	=> 'ÿ',
				'YO'	=> '¨',
				'Yo'	=> '¨',
				'ZH'	=> 'Æ',
				'Zh'	=> 'Æ',
				'KH'	=> 'Õ',
				'Kh'	=> 'Õ',
				'TC'	=> 'Ö',
				'Tc'	=> 'Ö',
				'CH'	=> '×',
				'Ch'	=> '×',
				'SH'	=> 'Ø',
				'Sh'	=> 'Ø',
				'YU'	=> 'Þ',
				'Yu'	=> 'Þ',
				'YA'	=> 'ß',
				'Ya'	=> 'ß',
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
