#test
#!/usr/bin/perl -w
use POSIX;
$string_text="";
my @letter_array;
my $count;
my %letter_hash;
my $subst_string;
my @untouched_text;
# Initalise array with
sub initialise {
  check_usage();
  $file = $ARGV[0];
  if($file =~ /\.txt/){
    open my $p, "$file" or die "can not open $file: $!";
       @text = <$p>;
    close $p;
  }else{
    @text = $file;
  }
  return set_globals(@text);
}

sub check_usage {
  if(!$ARGV[0]){
    print "Usage is ./cipher_helper.pl [textfile.txt]|[string]\n";
    exit 0;
  }
}

sub set_globals {
  my @text =  @_;
  @untouched_text = @text;
  foreach $line (@text){
    $line =~ s/\s|\n//g;
    $string_text = "$string_text$line";
    $subst_string = $string_text;
    @letter_array = split(//, $string_text);
    $count = $#letter_array;
  }
}
sub process_request {
    print "------------------------------------------------------------\n\n";
    $req = $_[0];
    if($req =~ /FreqAnalysis|1/){
      if(!%letter_hash){
        %letter_hash = get_letter_count();
      }
      print "FrequencyAnalysis result is -->\n\n";
      print_letter_count();
    }
    elsif($req =~ /Ioc|2/){
      if(!%letter_hash){
        %letter_hash = get_letter_count();
      }
      ioc(%letter_hash);
    }
    elsif($req =~ /TextSub|4/){
      if(!%letter_hash){
        %letter_hash = get_letter_count();
      }
      $subst_string = sub_letter($subst_string);
    }
    elsif($req =~ /PrintSub|PS|ps/){
      print_sub();
    }
    elsif($req =~ /ResetText|5/){
      $subst_string = $string_text;
      print_original();
    }
    elsif($req =~ /Print|3/){
        print_original();
    }
    elsif($req =~/RailCipher|6/){
      my $rail = 2;
      while($rail < 8){
        print("\nStart ATTEMPT\n");
        print("$rail\n");
        rail_cipher($rail);
        print("\nEND ATTEMPT\n");
        $rail = $rail+1;
      }
    }
}

sub transpose {

}
sub sub_letter {
  $sub_string = $_[0];
  print("Enter letter you'd like to substitute out ( the one to delete) : \n");
  $sub_out = <STDIN>;
  chomp $sub_out;
  print("Enter the letter you'd like to sub in ( the one to modify for) : \n");
  $sub_in = <STDIN>;
  chomp($sub_in);
  $sub_string =~ s/$sub_out/$sub_in/eg;
  return $sub_string;
}

sub print_original {
  print "$string_text\n";
}
sub print_sub {
  print "$subst_string\n";
}

sub print_nth {
  $nth = $_[0];
}
sub induce_interactivity {
  print "------------------------------------------------------------\n";
  print("Please enter option- current options are : \n 1. FreqAnalysis \n 2. Ioc - (index of coincedence)\n 3. Print \n 4. TextSub \n 5. ResetText\n");
  print("Enter desired functionality: ");
  $request = <STDIN>;
  process_request($request);
  induce_interactivity();
}

sub main {
  initialise();
  induce_interactivity();
}

main();

# Uses global to create hash of letters
sub get_letter_count {
  foreach $char (split //, $string_text) {
    if(!exists $letter_hash{$char}){
      $letter_hash{$char} = 1;
    }else{
      $letter_hash{$char}++;
    }
  }
  return %letter_hash;
}

sub print_letter_count {
  foreach my $key (sort{ $letter_hash{$b} <=> $letter_hash{$a}} keys %letter_hash){
    my $perc = ($letter_hash{$key}/$#letter_array)*100;
    print "[$key]=>$perc %\n";
  }
  print "\n";
}
sub ioc {
  my (%l_hash) = @_;
  my $sum = 0;
  foreach $key (keys %l_hash){
    $sum += $l_hash{$key}*($l_hash{$key}-1);
  }
  $res = $sum/($count*($count-1));
  print "Index of coicendence is => $res\n";
}

sub rail_cipher {
  my $key = $_[0];
  my $cycle = ($key*2)-2;

  my $text_length = $#letter_array;
  my $line_width = $text_length+1;

  my $array_count = 0;
  my @outputarray = ();
  $array_size = $line_width*$key;
  while($array_count < $array_size){
    $outputarray[$array_count] = 0;
    $array_count++;
  }

  $array_count = 0;
  my $width = floor($text_length/$cycle);
  my $num_placed_track = 0;
  my $level = 0;
  my $tracker = 0;
  my $next_letter_placement = $cycle-1;

  while($array_count < $text_length){
    #base scenario
    if($array_count == 0){
      $outputarray[$tracker] = $letter_array[0];
      $tracker = $tracker + $next_letter_placement;
      $num_placed_track++;
    }else{
      if($level == 0){

      }elsif($level > 0 && $level < $cycle-2){
        #Middle rows
      }elsif($level == $cycle-1){

      }
    }

  }


  printf("OA: $#outputarray, AS: $array_size, lw: $line_width\n");
  #
  # while($array_count < $array_size){
  #   printf("%2s", $letter_array[$array_count]);
  #   $array_count ++;
  # }
}

sub num_placed {
  $width = $_[0];
  $tracker = $_[1];

  if($width == $tracker){

  }
}

sub print_new_line {
  $val = $_[0];
  $c = $_[1];
  if($val == ($c-2)){
    print("\n");
    return 1;
  }
  return 0;
}

my $alph = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
#
#
# sub rail_cipher {
#   my $height = $_[0];
#   my $cycle = ($height*2)-2;
#
#
#   my $array_size = $#letter_array;
#   my $width = floor($array_size/$cycle);
#   my $cycle_count = 1;
#   my $array_count = 0;
#   $counter = 0;
#
#   while($array_count < $array_size){
#     printf("%2s", $letter_array[$array_count]);
#     $array_count ++;
#     while($cycle_count < $cycle){
#       printf("%2s", ".");
#       $cycle_count = $cycle_count + 1;
#       $counter = $counter + 1;
#       if(print_new_line($counter, $array_size)){
#         $counter = 0;
#       }
#     }
#     $cycle_count = 1;
#     if(print_new_line($counter, $array_size)){
#       $counter = 0;
#     }
#     printf("%2s", $letter_array[$array_count]);
#     $counter = $counter + 1;
#     if(print_new_line($counter, $array_size)){
#       $counter = 0;
#     }
#     while($cycle_count < $cycle){
#       printf("%2s", ".");
#       $cycle_count = $cycle_count + 1;
#       $counter = $counter + 1;
#       if(print_new_line($counter, $array_size)){
#         $counter = 0;
#       }
#     }
#     $cycle_count = 1;
#     $array_count = $array_count+1;
#   }
# }
