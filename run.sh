# Variables
node=$(pwd)

# Create file structure
mkdir -p results && cd results
mkdir -p filtered_trees
mkdir -p unfiltered_trees
mkdir -p count_tables

cd $node/data/
for folder in */
do
    echo "Entering dir "$folder"..."
    cd $folder
    echo "Creating subfolders..."
    mkdir ${folder%/}"_trees"
    mkdir ${folder%/}"_u_trees"
    echo "Copying files..."
    cp -r ../../bin/denoising .
    cp -r ../../bin/UserDefinedExceptions.py .
    for file in *.msl
    do
        # Get unfiltered tree
        echo "Running fastprot on "$file"..."
        fastprot $file > $file"_fp"
        echo "Running fnj on fastprot outfile..."
        fnj -O newick $file"_fp" > $file"_tree"
        rm -rf $file"_fp"
        echo "Moving tree to unfiltered trees dir..."
        mv -f $file"_tree" ${folder%/}"_u_trees"
        # Get filtered trees
        echo "Running denoising on "$file"..."
        ./denoising $file > $file"_out"
        echo "Running fastprot on "$file"_out..."
        fastprot $file"_out" > $file"_fp"
        rm -rf $file"_out"
        echo "Running fnj on fastprot outfile..."
        fnj -O newick $file"_fp" > $file"_tree"
        rm -rf $file"_fp"
        echo "Moving filtered tree to filtered trees dir..."
        mv -f $file"_tree" ${folder%/}"_trees"
    done
    echo "Copying reference tree to subfolders..."
    cp -r *.tree ${folder%/}"_trees"
    cp -r *.tree ${folder%/}"_trees"
    echo "Moving subfolders to results directory..."
    mv -f ${folder%/}"_trees" ../../results/filtered_trees/
    mv -f ${folder%/}"_u_trees" ../../results/unfiltered_trees/
    # Cleanup
    echo "Cleaning up..."
    rm -rf denoising *.py __*
    echo "Exiting "$folder"..."
    cd ..
done
echo "Entering results directory..."
cd $node/results/
for folder in *_trees/
do
    echo "Creating subfolders in count_tables..."
    cd count_tables && mkdir -p ${folder%/} && cd ..
    cd $folder
    for subfolder in */
    do
        echo "Entering "$subfolder"..."
        cd $subfolder
        echo "Preparatory cleanup..."
        rm -rf differences* treecompare difftab *.py __*
        echo "Copying files..."
        cp -r $node/bin/treecompare .
        cp -r $node/bin/difftab .
        cp -r $node/bin/UserDefinedExceptions.py .
        for file in *_tree
        do
            # Compare acquired trees against reference tree, accumulate distances in a file
            echo "Comparing "$file" to reference tree and appending to differences..."
            ./treecompare --notext *.tree $file >> differences
        done
        echo "Creating database and running queries..."
        ./difftab differences > ${subfolder%/}"_differences.table"
        echo "Moving distance count table to count_tables..."
        mv -f ${subfolder%/}"_differences.table" $node/results/count_tables/${folder%/}/${subfolder%/}"_differences.table"
        # Cleanup
        echo "Cleaning up..."
        rm -rf differences* treecompare difftab *.py __*
        echo "Exiting "$subfolder"..."
        cd ..
    done
    echo "Exiting "$folder"..."
    cd ..
echo "Done..."
done
