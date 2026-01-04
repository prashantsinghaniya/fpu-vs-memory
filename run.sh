#!/bin/bash

GEM5_BIN="../gem5/build/RISCV/gem5.opt"
# GEM5_SCRIPT="../gem5/configs/deprecated/example/se.py"
GEM5_SCRIPT="../gem5/configs/deprecated/example/modify_se.py"
GEM5_OPTS="--cpu-type=O3CPU --num-cpus=1 --caches --l2cache"

# GEM5_OPTS="--cpu-type=MinorCPU --caches" 

INPUT_DIR="input_dir"
OUTPUT_DIR="output_dir"
DUMP_DIR="dump_dir"  #for .o and exec


#check for file name is given or not
if [ -z "$1" ]; then
    echo "Error: provide file name"
    echo "Usage: ./run.sh <file_name.s>"
    exit 1
fi

mkdir -p "$DUMP_DIR"
mkdir -p "$OUTPUT_DIR"

input_filename="$1"
filename_no_extension=$(basename "$input_filename" .s)
input_file="$INPUT_DIR/$input_filename"
object_file="$DUMP_DIR/$filename_no_extension.o"
executable_file="$DUMP_DIR/$filename_no_extension"



if [ ! -f "$input_file" ]; then
echo "Error: File not found at $input_file"
exit 1
fi

AS="riscv64-linux-gnu-as"
LD="riscv64-linux-gnu-ld"

echo "Starting Assembly for $input_filename.."
$AS "$input_file" -o "$object_file"

#check for assembly failure
if [ $? -ne 0 ]; then
    echo " Error: Assembly FAILED for $input_filename"
    exit 1
fi

echo "Assembly successful: $object_file"

echo "Starting Linker for $object_file"
$LD -T link.ld -e main "$object_file" -o "$executable_file"

#check for linker failure
if [ $? -ne 0 ]; then
    echo "Error : linker FAILED for $object_file"
    exit 1;
fi
echo "Linking successful: $executable_file"


echo "Execution started for $filename_no_extension"

sim_output_dir="$OUTPUT_DIR/$filename_no_extension"
mkdir -p "$sim_output_dir"

#sim's ouput location
stdout_file="$sim_output_dir/sim_stdout.txt"
stderr_file="$sim_output_dir/sim_stderr.txt"

#run
echo "Running gem5 with command:"
echo "$GEM5_BIN --outdir=$sim_output_dir $GEM5_SCRIPT $GEM5_OPTS --cmd=$executable_file"

$GEM5_BIN \
    --outdir="$sim_output_dir" \
    $GEM5_SCRIPT \
    $GEM5_OPTS \
    --cmd="$executable_file" \
    > "$stdout_file" \
    2> "$stderr_file"

#Check the exit code

if [ $? -eq 0 ]; then 
    echo "gem5 Execution Finished successfully for: $filename_no_extension"
else
    echo "gem5 Execution FAILED for: $filename_no_extionsion"
    echo "  Check logs in: $sim_output_dir"
fi
echo "----------------------------------------"




