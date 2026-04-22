def generate_ra_logic(num_entries, check_value, target_hits):
    """
    :param num_entries: Number of memory entries to check (e.g., 2)
    :param check_value: The value to check for at offset 0x3c (e.g., 0x191)
    :param target_hits: Total hits required to trigger the group (e.g., 49)
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
        
        # Format the offset to an 8-character zero-padded hex string
        offset_hex = f"{offset:08x}"
        
        # Build the block for the current entry:
        # 1. Recall remembered address
        # 2. Add Address from the calculated offset
        # 3. Add Hits (C:) if value at +0x3c equals the check_value
        block = (
            f"I:{{recall}}&536870911_"
            f"I:0xG{offset_hex}&536870911_"
            f"C:0xG0000003c={check_value}.1._"
        )
        
        logic_string += block

    # Add the final condition to evaluate target hits (0=1 is a dummy check to funnel AddHits)
    logic_string += f"0=1.{target_hits}."
    
    return logic_string

generated_logic = generate_ra_logic(num_entries=256, check_value=0x191, target_hits=49)

print("Generated Logic String:\n")
print(generated_logic)