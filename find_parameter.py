import sys
import re

def parse_gem5_stats(stats_file):
    """
    Parses a gem5 stats.txt file and returns a dictionary of values.
    """
    stats = {}
    
    try:
        with open(stats_file, 'r') as f:
            for line in f:
                # Skip empty lines or headers
                if not line.strip() or line.startswith('---'):
                    continue
                
                # Split the line (Name, Value, Description)
                parts = line.split()
                if len(parts) >= 2:
                    stat_name = parts[0]
                    stat_value = parts[1]
                    
                    # Store in dictionary (convert to float for math)
                    try:
                        stats[stat_name] = float(stat_value)
                    except ValueError:
                        pass # Handle non-numeric values (like 'nan')
    except FileNotFoundError:
        print(f"Error: Could not find file '{stats_file}'")
        sys.exit(1)

    return stats

def get_stat(stats_dict, key_list):
    """
    Helper to find a stat. Some gem5 versions use slightly different names 
    (e.g., 'system.cpu.cpi' vs 'system.cpu.dcache.overall_misses').
    Returns 0.0 if not found.
    """
    for key in key_list:
        if key in stats_dict:
            return stats_dict[key]
    return 0.0

def main():
    # Default to m5out/stats.txt if no argument provided
    file_path = sys.argv[1] if len(sys.argv) > 1 else print( "give me a file")
    
    print(f"Parsing file: {file_path}\n")
    data = parse_gem5_stats(file_path)

    # --- 1. General Simulation Stats ---
    sim_seconds = get_stat(data, ['simSeconds', 'sim_seconds'])
    num_cycles = get_stat(data, ['system.cpu.numCycles'])
    num_insts = get_stat(data, ['simInsts', 'simInsts'])
    
    cpi = get_stat(data, ['system.cpu.cpi'])
    ipc = get_stat(data, ['system.cpu.ipc'])

    # --- 2. Instruction Types (Committed) ---
    # Using committedInstType ensures we only count instructions that actually finished
    ld_insts = get_stat(data, ['system.cpu.commitStats0.numLoadInsts'])
    st_insts = get_stat(data, ['system.cpu.commitStats0.numStoreInsts'])
    
    int_alu = get_stat(data, ['system.cpu.commit.committedInstType_0::IntAlu'])
    int_mult = get_stat(data, ['system.cpu.commit.committedInstType_0::IntMult'])
    int_div = get_stat(data, ['system.cpu.commit.committedInstType_0::IntDiv'])
    float_cvt = get_stat(data, ['system.cpu.commit.committedInstType_0::FloatCvt'])
    
    # Floating point math (if needed for Total ALU calculation)
    float_add = get_stat(data, ['system.cpu.commit.committedInstType::FloatAdd'])
    float_mult = get_stat(data, ['system.cpu.commit.committedInstType::FloatMult'])

    # Calculations
    memory_access = ld_insts + st_insts
    # Total ALU is usually sum of integer and float math ops
    total_alu = int_alu + int_mult + int_div + float_cvt + float_add + float_mult

    # --- 3. Cache Stats (L1 D-Cache) ---
    # Note: Looking for overall_accesses, hits, and misses
    cache_hits = get_stat(data, ['system.cpu.dcache.overall_hits::total', 'system.cpu.dcache.overallHits::total'])
    cache_misses = get_stat(data, ['system.cpu.dcache.overall_misses::total', 'system.cpu.dcache.overallMisses::total'])
    
    # Cache demand is roughly Hits + Misses (or specifically ReadReq + WriteReq)
    cache_demand = cache_hits + cache_misses
    
    miss_rate = get_stat(data, ['system.cpu.dcache.overall_miss_rate::total', 'system.cpu.dcache.overallMissRate::total'])

    # --- 4. Print Table ---
    print(f"{'Parameter':<35} | {'Value'}")
    print("-" * 50)
    print(f"{'Sim seconds':<35} | {sim_seconds:.6f}")
    print(f"{'Total no of cycles':<35} | {int(num_cycles)}")
    print(f"{'Cycles per instruction':<35} | {cpi:.6f}")
    print(f"{'Instructions per cycle':<35} | {ipc:.6f}")
    print(f"{'Total no of instructions':<35} | {int(num_insts)}")
    print("-" * 50)
    print(f"{'Memory access (Ld + St)':<35} | {int(memory_access)}")
    print(f"{'Total no of ld instructions':<35} | {int(ld_insts)}")
    print(f"{'Total no of store instructions':<35} | {int(st_insts)}")
    print("-" * 50)
    print(f"{'intAlu':<35} | {int(int_alu)}")
    print(f"{'intMUL':<35} | {int(int_mult)}")
    print(f"{'intdiv':<35} | {int(int_div)}")
    print(f"{'floatcvt':<35} | {int(float_cvt)}")
    print(f"{'Total alu instructions':<35} | {int(total_alu)}")
    print("-" * 50)
    print(f"{'Cache demand (read+write)':<35} | {int(cache_demand)}")
    print(f"{'Cache hit':<35} | {int(cache_hits)}")
    print(f"{'Cache miss':<35} | {int(cache_misses)}")
    print(f"{'Miss rate':<35} | {miss_rate:.6f}")

if __name__ == "__main__":
    main()