def generate_ra_logic(num_entries, check_value, target_hits, name, shrine=False):
    """
    Generates a RetroAchievements logic string with a repeating pointer chain.
    
    :param num_entries: Number of memory entries to check (e.g., 2)
    :param check_value: The value to check for at offset 0x3c (e.g., 0x191)
    :param target_hits: Total hits required to trigger the group (e.g., 49)
    :param shrine: Boolean. If True, adds an AndNext condition to check offset 0x1C4 == 0
    :return: The formatted RA logic string
    """
    # Base pointer chain and Remember (K:) instruction
    prefix = (
        "I:0xG00436e94&536870911_"
        "I:0xG0008b21c&536870911_"
        "I:0xG000004c4&536870911_"
        "K:0xG00000020&536870911_"
    )
    
    logic_string = prefix
    
    for i in range(num_entries):
        # Calculate the starting offset (0x04) and add 0x14 for each subsequent entry
        offset = 0x04 + (i * 0x14)
        offset_hex = f"{offset:08x}"
        
        # The pointer chain to locate the specific object in memory
        pointer_chain = (
            f"I:{{recall}}&536870911_"
            f"I:0xG{offset_hex}&536870911_"
        )
        
        if shrine:
            # If shrine is True, we need an AndNext (N:) condition first.
            # Because pointers reset per condition, we must supply the pointer chain twice.
            block = (
                f"{pointer_chain}"
                f"N:0xG000001c4=0.0._"  # AndNext: +0x1C4 must equal 0
                f"{pointer_chain}"
                f"C:0xG0000003c={check_value}.1._"  # AddHits: +0x3C must equal check_value
            )
        else:
            # Original behavior
            block = (
                f"{pointer_chain}"
                f"C:0xG0000003c={check_value}.1._"
            )
            
        logic_string += block

    # Add the final condition to evaluate target hits
    logic_string += f"0=1.{target_hits}.\":{name}:...::::Pilzkopf:0:::::00000"
    
    return '111000020:"' + logic_string

# print("=== Standard Output (shrine=False) ===")
# print(generate_ra_logic(num_entries=256, check_value=0x191, target_hits=49, shrine=False))

print("\n=== Shrine Output (shrine=True) ===")
print(generate_ra_logic(num_entries=256, check_value=0x1F7, target_hits=40, name="Wow cheevo!", shrine=True))