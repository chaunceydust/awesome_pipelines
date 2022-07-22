use Bio::SearchIO;

my $tabdir = "./tabs";
my %idType = idType(); #id to type
my %typeCutoff = typeCutoff(); #type to similarity cutoff
my %typeClass = typeClass(); #type to higher class
my %classInfo = classInfo(); #class to description
#my %typeResis = typeResis(); #type to resistance
#my %typeRequire = typeRequire(); #type to requirement

#merge annotation files into excel sheet
sub mergeAnno
{
    my (@gnames) = @_;
    my $outfile = 'ProteinName.Anno_output.xls';
    open(OUT, ">$outfile");
    select OUT;
    my %annoInfo = ();
    foreach my $gname (@gnames)
    {
    $gname =~ s/\.blast.*$//;
	my $annofile = "$gname" . '.anno';
	open(FH, $annofile);
	my @data = <FH>;
	close FH;
	my $geneid = "";
	my $type = "";
	foreach my $line (@data)
	{
	    chomp $line;
	    unless ($line)
	    {
		next;
	    }
	    if ($line =~ /^\>(\S+)/)
	    {
		$geneid = $1;
#		if ($geneid =~ /^(\S+)\.\d$/)
#		{
#		    $geneid = $1;
#		}
	    }
	    elsif ($line =~ /^Type\t(\S+)/)
	    {
		$type = $1;
		$annoInfo{$type}{$gname}{$geneid} = 1;
	    }
	}
    }
#    print "Resistance Type\t";
	print "ProteinName Type\t";
    print "Description\t";
#    print "Resistance Profile\t";
#    print "Require\t";
    foreach my $gname (sort @gnames)
    {
	my $name = $gname;
	$name =~ s/\.blast.*$//;
	$name =~ s/\_/ /g;
	print $name, "\t";
    }
    print "\n";
    foreach my $type (sort keys %annoInfo)
    {
	print "$type\t";
	my $class = $typeClass{$type};
	print "$classInfo{$class}\t";
#	print join(', ', keys %{$typeResis{$type}}), "\t";
#	print join(', ', keys %{$typeRequire{$type}}), "\t";
	foreach my $gname (sort @gnames)
	{
	    if (exists $annoInfo{$type}{$gname})
	    {
		print join(', ', keys %{$annoInfo{$type}{$gname}}), "\t";
	    }
	    else
	    {
		print "\t";
	    }
	}
	print "\n";
    }
    close OUT;
    select STDOUT;
}

sub typeCutoff
{
    
    my $ori_tab = "$tabdir/ProteinName-originType.tab";
    open(FH, $ori_tab);
    my @data = <FH>;
    close FH;
    my %type2cutoff = ();
    foreach my $line (@data)
    {
	chomp $line;
	unless ($line)
	{
	    next;
	}
	my ($type, $id, $class, $idy) = split("\t", $line);
	unless ($idy)
	{
	    $idy = 80;
	}
#	my $lc_type = lc($type);
#	$type2cutoff{$lc_type} = $idy;
	$type2cutoff{$type} = $idy;
    }
    return %type2cutoff;
}

sub typeClass
{
    
    my $ori_tab = "$tabdir/ProteinName-originType.tab";
    open(FH, $ori_tab);
    my @data = <FH>;
    close FH;
    my %type2class = ();
    foreach my $line (@data)
    {
	chomp $line;
	unless ($line)
	{
	    next;
	}
	my ($type, $id, $class, $idy) = split("\t", $line);
#	my $lc_type = lc($type);
#	$class = lc($class);
#	$type2class{$lc_type} = $class;
	$type2class{$type} = $class;
    }
    return %type2class;
}

sub getGenome							# not used now
{
    my $file = "genomeList.tab";
    open(FH, $file);
    my @data = <FH>;
    close FH;
    my $tag = 0;
    my $name = "";
    my %genomes = ();
    foreach my $line (@data)
    {
	chomp $line;
	if ($line =~ /^\s*$/)
	{
	    next;
	}
	if ($line =~ /^\>taxonID/)
	{
	    $tag = 2;
	}
	elsif ($line =~ /^\>(.+)$/)
	{
	    $name = $1;
	    $name =~ s/\s/\_/g;
	    $tag = 1;
	}
	elsif ($tag == 1)
	{
	    $genomes{$name} = $line;
	}
    }
    return %genomes;
}

sub idType
{
    my $id2type = "$tabdir/ProteinName-abrg.tab";
    open(FH, $id2type);
    my @lines = <FH>;
    close FH;
    my %id2type = ();
    foreach my $line (@lines)
    {
	chomp $line;
	unless ($line)
	{
	    next;
	}
#	my ($id, $type, $tid) = split("\t", $line);
	my ($id, $type) = split ("\t", $line);
#	$type = lc($type);
	$id2type{$id} = $type;
    }
    return %id2type;
}

sub typeResis 								# not used now
{
    my $rp_file = "$tabdir/typeResis.tab";
    open(FH, $rp_file);
    my @rp_file = <FH>;
    close FH;
    my %type2resis = ();
    foreach my $line (@rp_file)
    {
	chomp $line;
	my ($type, @antibiotic) = split("\t", $line);
	$type = lc($type);
	foreach my $ab (@antibiotic)
	{
	    $type2resis{$type}{$ab} = 1;
	}
    }
    return %type2resis;
}

sub classInfo
{
    my $class_file = "$tabdir/ProteinName-classInfo.tab";
    open(FH, $class_file);
    my @class_desc = <FH>;
    close FH;
    my %class2info = ();
    foreach my $line (@class_desc)
    {
	chomp $line;
	unless ($line)
	{
	    next;
	}
	my ($class, $info) = split("\t", $line);
#	$class = lc($class);
	$class2info{$class} = $info;
    }
    return %class2info;
}

sub typeRequire 							# not used now
{
    my $require_file = "$tabdir/require.tab";
    open(FH, $require_file) or die("$require_file\n");
    my @require_data = <FH>;
    close FH;
    my %type2require = ();
    foreach my $line (@require_data)
    {
	chomp $line;
	unless ($line)
	{
	    next;
	}
	my ($type, @require) = split("\t", $line);
	$type = lc($type);
	foreach my $ele (sort @require)
	{
	    $ele = lc($ele);
	    $type2require{$type}{$ele} = 1;
	}
    }
    return %type2require;
}

#annotate the blast file
sub annoBlast
{
    my ($blastfile) = @_;
    $blastfile =~ /^(\S+)\.blast/;
    my $name = $1;
    my $outfile = $name . '.anno';
    open(OUT, ">$outfile");
    select OUT;
    my $blastio = new Bio::SearchIO (-file => "$blastfile", -format => "blast");
    while (my $blast = $blastio -> next_result)
    {
	my $hit = $blast -> next_hit;
	unless ($hit)
	{
	    next;
	}
	my $hsp = $hit -> next_hsp;
	unless ($hsp)
	{
	    next;
	}
	my $pct = $hsp -> percent_identity;
	my $hacc = $hit -> accession;
	my $qacc = $blast -> query_accession;
	if (exists $idType{$hacc})
	{}
	else
	{
	    next; #actually all should exist
	}
	my $type = $idType{$hacc};
	if (exists $typeClass{$type})
	{}
	else
	{
	    print "ERROR: this type $type can not be mapped to class\n";
	    exit;
	}
	my $class = $typeClass{$type};
	if ($pct < $typeCutoff{$type})
	{
	    next;
	}
	else
	{
	    print "\>$qacc\n";
	    print "BestHit\t$hacc\n";
	    print "Type\t$type\n";
	    print "Description\t$classInfo{$class}\n";
#	    print "Resistance\t";
#	    print join("\t", keys %{$typeResis{$type}}), "\n";
#	    if (exists $typeRequire{$type})
#	    {
#		print "Require\t";
#		print join("\t", keys %{$typeRequire{$type}}), "\n";
#	    }
	    print "Evalue\t", $hit -> significance(), "\n";
	    print "QueryLength\t", $blast -> query_length(), "\n";
	    print "HitLength\t", $hit -> length(), "\n";
	    print "HSPlength\t", $hsp -> hsp_length(), "\n";
	    printf("PercentIdentity\t%.2f\n", $pct);
	    print "\n";
	}
    }
    close OUT;
    select STDOUT;
}

1;
