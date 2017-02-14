package PriorityQueue;

use strict;
use warnings;

use Scalar::Util qw( blessed );
use POSIX;
use Carp;

################################################################################
# new
#       Creates an object of PriorityQueue class
#
# Returns
#       Blessed reference
################################################################################
sub new {
        my $class = shift;
        my $self  = { 
                queue => ["DEADEND"], # This would contain the array of data
                count => 0
        };  
        bless $self, $class;
        return $self;
}

################################################################################
# IsEmpty
#       Returns true of the queue is empty
#
# Returns:
#       Boolean
################################################################################
sub IsEmpty {
        my $self = shift;
        if($self->{count} == 0){ 
                return 1;
        }   
}

################################################################################                                                                                  
# Insert
#       Inserts an element in the priority queue
#
# Parameters:
#       Comparable elements
#
# Returns:
#       Nil
################################################################################
sub Insert  {
        my ($self, $value) = @_;
        $self->{count} += 1;
        @{$self->{queue}}[$self->{count}] = $value;
        $self->_Swim($self->{count});
}

################################################################################
# GetNext
#       Gets the next element in the element with high priority
#
# Returns:
#       Object with highest priority based on the _CompareTo implementation
################################################################################
sub GetNext {
        my $self = shift;
        if ($self->IsEmpty()){
                carp "The queue is empty, no more element to get";
                return;
        }
        my $returnvalue = @{$self->{queue}}[1];
        $self->_Exchange({FIRST => 1,SECOND => $self->{count}});
        $self->{count} -= 1;
        $self->_Sink(1);
        delete @{$self->{queue}}[$self->{count} + 1];
        return $returnvalue;
}

################################################################################
# _Swim
#       Moves up the element to appropriate position in the heap
#
# Parameters:
#       Index of the element in the heap
#
# Returns:
#       Nil
################################################################################
sub _Swim {
        my ($self, $objindex) = @_;
        while ($objindex > 1 && $self->_Greater({FIRST => floor($objindex/2) , SECOND => $objindex})){ 
                $self->_Exchange({FIRST => floor($objindex/2), SECOND => $objindex});
                $objindex = floor($objindex / 2);
        }
}

################################################################################
# _Sink
#       Moves down the element to appropriate position in the heap
#
# Parameters:
#       Index of element in the heap
#
# Returns:
#       Nil
################################################################################
sub _Sink {
        my ($self, $objindex) = @_;
        while (2 * $objindex <= $self->{count}){
                my $j = 2 * $objindex;
                if ($j < $self->{count} && $self->_Greater({FIRST => $j, SECOND => $j+1})){
                        $j += 1;
                }
                if (!($self->_Greater({FIRST => $objindex, SECOND => $j}))){
                        last;
                }
                $self->_Exchange({FIRST => $objindex, SECOND => $j});
                $objindex = $j;
        }
}

################################################################################
# _Less
#       Returns lesser of the two elements
#
# Parameters:
#       $args
#               FIRST => first element
#               SECOND => second element
#
# Returns:
#       Lesser of the two elements based on the comparision done by _CompareTo
################################################################################
sub _Less {
        my ($self, $args) = @_;
        if ($self->_CompareTo($args) == -1){
                return 1;
        }
}

################################################################################
# _Greater
#       Returs greater of the two elements
#
# Parameters:
#       $args
#               FIRST => first element
#               SECOND => second element
#
# Returns:
#       Greater of the two elements based on the comparision done by _CompareTo
################################################################################
sub _Greater {
        my ($self, $args) = @_;
        if ($self->_CompareTo($args) == 1){
                return 1;
        }
}
################################################################################                                                                                  
# _Exchange
#       Exchanges position of two elements in the queue
#
# Parameters:
#       $args
#               FIRST => first element
#               SECOND => second element
# Returns:
#       Nil
################################################################################
sub _Exchange {
        my ($self, $args) = @_;
        my $i = $args->{FIRST};
        my $j = $args->{SECOND};
        my $temp = @{$self->{queue}}[$i];
        @{$self->{queue}}[$i] = @{$self->{queue}}[$j];
        @{$self->{queue}}[$j] = $temp;
}

################################################################################
# _CompareTo
#       This _CompareTo operator should be overridden by the inheriting module
#       to compare the objects the queue is going to hold
#
# Parameters:
#       $args
#               FIRST => first element
#               SECOND => second element
# Returns:
#       Nil
################################################################################
sub _CompareTo {
        my ($self, $args) = @_;
        my $a = $args->{FIRST};
        my $b = $args->{SECOND};
        if (blessed($a) ne  blessed($b)){
                confess "Objects are not comparable";
        }
        if (@{$self->{queue}}[$a] == @{$self->{queue}}[$b]){
                return 0;
        }
        elsif (@{$self->{queue}}[$a] < @{$self->{queue}}[$b]){
                return -1;
        }
        else{
                return 1;
        }
}
1;
