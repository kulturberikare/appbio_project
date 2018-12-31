# Create trees from sequence files
echo "Creating dir trees..."
mkdir trees
for file in *.msl
do
    echo "Running denoising on "$file"..."
    ./denoising $file > $file"_out"
    echo "Running fastprot on "$file"_out..."
    fastprot $file"_out" > $file"_fp"
    rm -rf $file"_out"
    echo "Running fnj on fastprot outfile..."
    fnj -O newick $file"_fp" > $file"_tree"
    rm -rf $file"_fp"
    echo "Moving tree to trees dir..."
    mv -f $file"_tree" trees/
done

# Compare acquired trees against reference tree, accumulate distances in a file
cd trees
for file in *_tree
do
    echo "Comparing "$file" to reference tree and appending to differences..."
    ./treecompare *.tree $file >> differences
done
