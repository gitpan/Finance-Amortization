package Finance::Amortization;

use strict;
use warnings;

our $VERSION = '0.2';

=head1 NAME

Finance::Amortization - Simple Amortization Schedules

=head1 SYNOPSIS

use Finance::Amortization

# make a new schedule

$amortization = new Finance::Amortization(principal => 100000, rate = 0.06/12,
	periods = 360);

# get the balance after a the twelveth period

$balance = $amortization->balance(12)

# get the interest paid during the twelfth period

$interest = $amortization->interest(12);

=head1 DESCRIPTION

Finance::Amortization is a simple object oriented interface to an
amortization table.  Pass in the principal to be amortized, the number
of payments to be made, and the interest rate per payment.  It will
calculate the rest on demand, and provides a few methods to ask
for the state of the table after a given number of periods.

Finance::Amortization is written in pure perl and does not depend
on any other modules.  It exports no functions; all access is via
methods called on an amortization object.  (Except for new(), of course.)

=cut

=head2 new()

$am = Finance::Amortization->new(principal = 0, rate = 0, periods = 0);

Creates a new amortization object.  Calling interface is hash style,
and the fields principal, rate, and periods are available, all defaulting
to zero.

The rate is the interest rate *per period*.  Thus for monthly payments
with an annual interest rate, you will need to divide by 12.

=cut

sub new{
	my $pkg = shift;
	# bless package variables
	bless{
	principal => 0.00,
	rate => 0.00,
	periods => 0,
	@_}, $pkg;
}

=head2 rate()

$rate_per_period = $am->rate()

returns the interest rate per period.  Ignores any arguments.

=cut

sub rate {
	my $am = shift;
	return $am->{'rate'};
}	

=head2 principal()

$initial_value = $am->principal()

returns the initial principal being amortized.  Ignores any arguments.

=cut

sub principal {
	my $am = shift;
	return $am->{'principal'};
}	

=head2 periods()

$number_of_periods = $am->periods()

returns the number of periods in which the principal is being amortized.
Ignores any arguments.

=cut

sub periods {
	my $am = shift;
	return $am->{'periods'};
}	

#P = r*L*(1+r)^n/{(1+r)^n - 1}

=head2 payment()

$pmt = $am->payment()

returns the payment per period.  This method will cache the value the
first time it is called.

=cut

sub payment {
	my $am = shift;

	if ($am->{'payment'}) {
		return $am->{'payment'}
	}

	my $r = $am->rate;
	my $r1 = $r + 1;
	my $n = $am->periods();
	my $p = $am->principal;

	if ($r == 0) {
		return $am->{'payment'} = $p / $n;
	}

	$am->{'payment'} = $r * $p * $r1**$n / ($r1**$n-1);
}

=head2 balance(n)

$balance = $am->balance(12);

Returns the balance of the amortization after the period given in the
argument

=cut

sub balance {
	my $am = shift;
	my $period = shift;
	return $am->principal() if $period == 0;

	return 0 if ($period < 1 or $period > $am->periods);

	my $rate = $am->rate;
	my $rate1 = $rate + 1;
	my $periods = $am->periods();
	my $principal = $am->principal;
	my $pmt = $am->payment();

	return $principal * $rate1 ** $period
		 - $pmt*($rate1**$period - 1)/$rate;

}

=head2 interest(n)

$interest = $am->interest(12);

Returns the interest paid in the period given in the argument

=cut

sub interest {
	my $am = shift;
	my $period = shift;

	return 0 if ($period < 1 or $period > $am->periods);

	my $rate = $am->rate;
	my $rate1 = $rate + 1;
	my $periods = $am->periods();
	my $principal = $am->principal;
	my $pmt = $am->payment();

	return $rate * $am->balance($period - 1);
}

=head1 BUGS

This module uses perl's floating point for financial calculations.  This
may introduce inaccuracies.

=head1 TODO

Use Math::BigRat for the calculations.

Provide amortizers for present value, future value, annuities, etc.

Allow for caching calculated values.

Provide output methods and converters to various table modules.
HTML::Table, Text::Table, and Data::Table come to mind.

Write test scripts.

Better checking for errors and out of range input.  Return undef
in these cases.

=head1 AUTHOR

Nathan Wagner <nw@hydaspes.if.org>

=cut

1;


__END__
