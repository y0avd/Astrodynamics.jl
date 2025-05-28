# Export useful SPICE functions for convenience
export utc2et, et2utc, spkezr, oscltx, bodvrd, furnsh

# Export functions
export load_spice_kernels

"""
Load all SPICE kernels from the specified directory.
This should be called by the user's project after adding required kernels.
"""
function load_spice_kernels(kernel_dir=joinpath(pwd(), "kernels"))
    if !isdir(kernel_dir)
        error("Kernels directory not found at $kernel_dir. Please create a 'kernels' directory in your project root and download the required SPICE kernels.")
    end
    
    # Common SPICE kernel extensions
    kernel_extensions = [".tls", ".bsp", ".tpc", ".tf", ".ti", ".tsc", ".ik", ".tk", ".pck", ".bc", ".bpc", ".tsp"]
    
    # Load all kernel files in the directory
    loaded = false
    for file in readdir(kernel_dir)
        # Check if file has a known SPICE kernel extension
        if any(endswith.(file, kernel_extensions))
            @info "Loading kernel: $file"
            furnsh(joinpath(kernel_dir, file))
            loaded = true
        end
    end
    
    if !loaded
        error("No SPICE kernel files found in $kernel_dir. Kernel files should have extensions: $(join(kernel_extensions, ", "))")
    end
end