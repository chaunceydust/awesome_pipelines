

##拼接注释
WORKPATH=/home/dell/testdata/Fungi/
SPECIES=candida_albicans
PROPATH=/home/dell/testdata/Fungi/proteins
conda activate unicycler
cd $WORKPATH
unicycler -1 $WORKPATH/reads/short_1.fq -2 $WORKPATH/reads/short_2.fq -l $WORKPATH/reads/long.fq.gz -o unicycler

# assuming it is in your PATH, now you can run this script as if it were the funannotate executable script
mkdir $WORKPATH/funanno
cd $WORKPATH/funanno
cp $WORKPATH/unicycler/assembly.fasta ./
/home/dell/software/funannotate/funannotate-docker mask -i assembly.fasta -o masked.fasta --cpus THREADS
/home/dell/software/funannotate/funannotate-docker sort -i masked.fasta -o sorted.fasta -s --minlen 1000
/home/dell/software/funannotate/funannotate-docker predict -i sorted.fasta -o predict  -s $SPECIES --cpus THREADS


##进化溯源
#orthofinder
cp -r $PROPATH $WORKPATH/Prodata
cp $WORKPATH/funanno/predict/predict_results/$SPECIES.proteins.fa  $WORKPATH/Prodata
conda activate orthofinder
orthofinder -f $WORKPATH/Prodata -S blast -M msa -t 2 -oa -o $WORKPATH/orthofinder
OK!
FILE=`ls  $WORKPATH/orthofinder/*/MultipleSequenceAlignments/SpeciesTreeAlignment.fa`

#iqtree
#对align后的蛋白序列建树
mkdir iqtree
cd iqtree
/home/dell/software/iqtree-2.2.0-Linux/bin/iqtree2 -s $FILE -m LG+G4 -pre PREFIX -bb 1000 -nt 8
open $WORKPATH/iqtree

打开figtree
cd /home/dell/software/FigTree_v1.4.4
./bin/figtree


################################################################################################################################
funannotate-docker species
  Species                                    Augustus               GeneMark   Snap   GlimmerHMM   CodingQuarry   Date      
  Conidiobolus_coronatus                     augustus pre-trained   None       None   None         None           2022-04-26
  E_coli_K12                                 augustus pre-trained   None       None   None         None           2022-04-26
  Xipophorus_maculatus                       augustus pre-trained   None       None   None         None           2022-04-26
  adorsata                                   augustus pre-trained   None       None   None         None           2022-04-26
  aedes                                      augustus pre-trained   None       None   None         None           2022-04-26
  amphimedon                                 augustus pre-trained   None       None   None         None           2022-04-26
  ancylostoma_ceylanicum                     augustus pre-trained   None       None   None         None           2022-04-26
  anidulans                                  augustus pre-trained   None       None   None         None           2022-04-26
  arabidopsis                                augustus pre-trained   None       None   None         None           2022-04-26
  aspergillus_fumigatus                      augustus pre-trained   None       None   None         None           2022-04-26
  aspergillus_nidulans                       augustus pre-trained   None       None   None         None           2022-04-26
  aspergillus_oryzae                         augustus pre-trained   None       None   None         None           2022-04-26
  aspergillus_terreus                        augustus pre-trained   None       None   None         None           2022-04-26
  b_pseudomallei                             augustus pre-trained   None       None   None         None           2022-04-26
  bombus_impatiens1                          augustus pre-trained   None       None   None         None           2022-04-26
  bombus_terrestris2                         augustus pre-trained   None       None   None         None           2022-04-26
  botrytis_cinerea                           augustus pre-trained   None       None   None         None           2022-04-26
  brugia                                     augustus pre-trained   None       None   None         None           2022-04-26
  c_elegans_trsk                             augustus pre-trained   None       None   None         None           2022-04-26
  cacao                                      augustus pre-trained   None       None   None         None           2022-04-26
  caenorhabditis                             augustus pre-trained   None       None   None         None           2022-04-26
  camponotus_floridanus                      augustus pre-trained   None       None   None         None           2022-04-26
  candida_albicans                           augustus pre-trained   None       None   None         None           2022-04-26
  candida_guilliermondii                     augustus pre-trained   None       None   None         None           2022-04-26
  candida_tropicalis                         augustus pre-trained   None       None   None         None           2022-04-26
  chaetomium_globosum                        augustus pre-trained   None       None   None         None           2022-04-26
  chicken                                    augustus pre-trained   None       None   None         None           2022-04-26
  chiloscyllium                              augustus pre-trained   None       None   None         None           2022-04-26
  chlamy2011                                 augustus pre-trained   None       None   None         None           2022-04-26
  chlamydomonas                              augustus pre-trained   None       None   None         None           2022-04-26
  chlorella                                  augustus pre-trained   None       None   None         None           2022-04-26
  ciona                                      augustus pre-trained   None       None   None         None           2022-04-26
  coccidioides_immitis                       augustus pre-trained   None       None   None         None           2022-04-26
  coprinus                                   augustus pre-trained   None       None   None         None           2022-04-26
  coprinus_cinereus                          augustus pre-trained   None       None   None         None           2022-04-26
  coyote_tobacco                             augustus pre-trained   None       None   None         None           2022-04-26
  cryptococcus                               augustus pre-trained   None       None   None         None           2022-04-26
  cryptococcus_neoformans_gattii             augustus pre-trained   None       None   None         None           2022-04-26
  cryptococcus_neoformans_neoformans_B       augustus pre-trained   None       None   None         None           2022-04-26
  cryptococcus_neoformans_neoformans_JEC21   augustus pre-trained   None       None   None         None           2022-04-26
  culex                                      augustus pre-trained   None       None   None         None           2022-04-26
  debaryomyces_hansenii                      augustus pre-trained   None       None   None         None           2022-04-26
  elephant_shark                             augustus pre-trained   None       None   None         None           2022-04-26
  encephalitozoon_cuniculi_GB                augustus pre-trained   None       None   None         None           2022-04-26
  eremothecium_gossypii                      augustus pre-trained   None       None   None         None           2022-04-26
  fly                                        augustus pre-trained   None       None   None         None           2022-04-26
  fly_exp                                    augustus pre-trained   None       None   None         None           2022-04-26
  fusarium                                   augustus pre-trained   None       None   None         None           2022-04-26
  fusarium_graminearum                       augustus pre-trained   None       None   None         None           2022-04-26
  galdieria                                  augustus pre-trained   None       None   None         None           2022-04-26
  generic                                    augustus pre-trained   None       None   None         None           2022-04-26
  heliconius_melpomene1                      augustus pre-trained   None       None   None         None           2022-04-26
  histoplasma                                augustus pre-trained   None       None   None         None           2022-04-26
  histoplasma_capsulatum                     augustus pre-trained   None       None   None         None           2022-04-26
  honeybee1                                  augustus pre-trained   None       None   None         None           2022-04-26
  human                                      augustus pre-trained   None       None   None         None           2022-04-26
  japaneselamprey                            augustus pre-trained   None       None   None         None           2022-04-26
  kluyveromyces_lactis                       augustus pre-trained   None       None   None         None           2022-04-26
  laccaria_bicolor                           augustus pre-trained   None       None   None         None           2022-04-26
  leishmania_tarentolae                      augustus pre-trained   None       None   None         None           2022-04-26
  lodderomyces_elongisporus                  augustus pre-trained   None       None   None         None           2022-04-26
  magnaporthe_grisea                         augustus pre-trained   None       None   None         None           2022-04-26
  maize                                      augustus pre-trained   None       None   None         None           2022-04-26
  maize5                                     augustus pre-trained   None       None   None         None           2022-04-26
  mnemiopsis_leidyi                          augustus pre-trained   None       None   None         None           2022-04-26
  nasonia                                    augustus pre-trained   None       None   None         None           2022-04-26
  nematostella_vectensis                     augustus pre-trained   None       None   None         None           2022-04-26
  neurospora                                 augustus pre-trained   None       None   None         None           2022-04-26
  neurospora_crassa                          augustus pre-trained   None       None   None         None           2022-04-26
  parasteatoda                               augustus pre-trained   None       None   None         None           2022-04-26
  pchrysosporium                             augustus pre-trained   None       None   None         None           2022-04-26
  pea_aphid                                  augustus pre-trained   None       None   None         None           2022-04-26
  pfalciparum                                augustus pre-trained   None       None   None         None           2022-04-26
  phanerochaete_chrysosporium                augustus pre-trained   None       None   None         None           2022-04-26
  pichia_stipitis                            augustus pre-trained   None       None   None         None           2022-04-26
  pisaster                                   augustus pre-trained   None       None   None         None           2022-04-26
  pneumocystis                               augustus pre-trained   None       None   None         None           2022-04-26
  rhincodon                                  augustus pre-trained   None       None   None         None           2022-04-26
  rhizopus_oryzae                            augustus pre-trained   None       None   None         None           2022-04-26
  rhodnius                                   augustus pre-trained   None       None   None         None           2022-04-26
  rice                                       augustus pre-trained   None       None   None         None           2022-04-26
  s_aureus                                   augustus pre-trained   None       None   None         None           2022-04-26
  s_pneumoniae                               augustus pre-trained   None       None   None         None           2022-04-26
  saccharomyces                              augustus pre-trained   None       None   None         None           2022-04-26
  saccharomyces_cerevisiae_S288C             augustus pre-trained   None       None   None         None           2022-04-26
  saccharomyces_cerevisiae_rm11-1a_1         augustus pre-trained   None       None   None         None           2022-04-26
  schistosoma                                augustus pre-trained   None       None   None         None           2022-04-26
  schistosoma2                               augustus pre-trained   None       None   None         None           2022-04-26
  schizosaccharomyces_pombe                  augustus pre-trained   None       None   None         None           2022-04-26
  scyliorhinus                               augustus pre-trained   None       None   None         None           2022-04-26
  sealamprey                                 augustus pre-trained   None       None   None         None           2022-04-26
  strongylocentrotus_purpuratus              augustus pre-trained   None       None   None         None           2022-04-26
  sulfolobus_solfataricus                    augustus pre-trained   None       None   None         None           2022-04-26
  template_prokaryotic                       augustus pre-trained   None       None   None         None           2022-04-26
  tetrahymena                                augustus pre-trained   None       None   None         None           2022-04-26
  thermoanaerobacter_tengcongensis           augustus pre-trained   None       None   None         None           2022-04-26
  tomato                                     augustus pre-trained   None       None   None         None           2022-04-26
  toxoplasma                                 augustus pre-trained   None       None   None         None           2022-04-26
  tribolium2012                              augustus pre-trained   None       None   None         None           2022-04-26
  trichinella                                augustus pre-trained   None       None   None         None           2022-04-26
  ustilago                                   augustus pre-trained   None       None   None         None           2022-04-26
  ustilago_maydis                            augustus pre-trained   None       None   None         None           2022-04-26
  verticillium_albo_atrum1                   augustus pre-trained   None       None   None         None           2022-04-26
  verticillium_longisporum1                  augustus pre-trained   None       None   None         None           2022-04-26
  volvox                                     augustus pre-trained   None       None   None         None           2022-04-26
  wheat                                      augustus pre-trained   None       None   None         None           2022-04-26
  yarrowia_lipolytica                        augustus pre-trained   None       None   None         None           2022-04-26
  zebrafish                                  augustus pre-trained   None       None   None         None           2022-04-26


Options for this script:
 To print a parameter file to terminal:
   funannotate species -p myparameters.json
 To print the parameters details from a species in the database:
 
 
 
   funannotate species -s aspergillus_fumigatus
 To add a new species to database:
   funannotate species -s new_species_name -a new_species_name.parameters.json
