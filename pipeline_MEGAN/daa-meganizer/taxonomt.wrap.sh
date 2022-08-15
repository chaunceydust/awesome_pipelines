for f in MEGAN-taxonomy3.txt;
do
    sed -i "s/\x27/ /" $f
    sed -i 's|size=||' $f
    sed -i "s/$(echo '\t')/;/" $f
    #get rid of single/double quotes in taxon names KP
    sed -i "s/'//g" $f
    sed -i 's/"//g' $f
done

