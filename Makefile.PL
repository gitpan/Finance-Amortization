use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Finance::Amortization',
    'VERSION_FROM'	=> 'Amortization.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
);
