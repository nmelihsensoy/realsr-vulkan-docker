# Containerized RealSR

Requires [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit) installed on the Host machine to work. `nvidia-container-toolkit-ubuntu.sh` script can be used for installing to Ubuntu. For other distros there is a guide from Nvidia in [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)

## Vulkaninfo

[`Vulkaninfo`](https://vulkan.lunarg.com/doc/view/1.2.148.1/windows/vulkaninfo.html) tool also shipped with the image and can be used as following: 

```
> sudo docker run --rm --gpus all -it --entrypoint="vulkaninfo" ghcr.io/nmelihsensoy/realsr-vulkan -h

vulkaninfo - Summarize Vulkan information in relation to the current environment.

USAGE: 
    vulkaninfo --summary
    vulkaninfo -o <filename> | --output <filename>
    vulkaninfo -j | -j=<gpu-number> | --json | --json=<gpu-number>
    vulkaninfo --text
    vulkaninfo --html
    vulkaninfo --show-formats
    vulkaninfo --show-tool-props

[...]
```

## Usage

```
> sudo docker run --rm --gpus all -it ghcr.io/nmelihsensoy/realsr-vulkan
Usage: realsr-ncnn-vulkan -i infile -o outfile [options]...

  -h                   show this help
  -v                   verbose output
  -i input-path        input image path (jpg/png/webp) or directory
  -o output-path       output image path (jpg/png/webp) or directory
  -s scale             upscale ratio (4, default=4)
  -t tile-size         tile size (>=32/0=auto, default=0) can be 0,0,0 for multi-gpu
  -m model-path        realsr model path (default=models-DF2K_JPEG)
  -g gpu-id            gpu device to use (-1=cpu, default=auto) can be 0,1,2 for multi-gpu
  -j load:proc:save    thread count for load/proc/save (default=1:2:2) can be 1:2,2,2:2 for multi-gpu
  -x                   enable tta mode
  -f format            output image format (jpg/png/webp, default=ext/png)
```
## Example

Upscaling `./images/input.png` file to `./images/output.jpg`

```
> sudo docker run --rm -v `pwd`/images:/tmp --gpus all -it ghcr.io/nmelihsensoy/realsr-vulkan -i /tmp/input.png -o /tmp/output.jpg -s 4 -x -m models-DF2K
```

For other images, just put images into `images` folder and change the `input.png`, `output.jpg` parts.

## Credits

[realsr-ncnn-vulkan](https://github.com/nihui/realsr-ncnn-vulkan)
