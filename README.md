# MATLAB Image Editor GUI

## Overview

This project is a MATLAB/Octave-based Image Editor with both single-image and batch processing capabilities. It allows users to apply a variety of image filters and adjust their intensities directly through a GUI interface.

## Features

* **Single Image Editing:**

  * Apply filters to a single image.
  * Adjust intensity for each filter.

* **Batch Processing:**

  * Process multiple images in a selected folder.
  * Apply selected filters to all images at once.

* **Filters Available:**

  * Brightness (`adjustBrightness.m`)
  * Contrast (`adjustContrast.m`)
  * Grayscale (`adjustGrayscale.m`)
  * Sepia (`adjustSepia.m`)
  * Negative (`adjustNegative.m`)

* **User-Friendly Interface:**

  * Easy selection between single image and batch folder processing.
  * Progress indication and confirmation dialogues.

## File Structure

```
batch_process.m          % Handles batch image processing
single_image_editor.m    % Handles single image editing
main.m                   % Entry point of the application
filters/                 % Folder containing all filter functions
  adjustBrightness.m
  adjustContrast.m
  adjustGrayscale.m
  adjustSepia.m
  adjustNegative.m
LICENSE                  % License information
```

## Getting Started

1. Ensure MATLAB or Octave is installed on your system.
2. Clone or download this repository.
3. Open `main.m` in MATLAB or Octave.
4. Run the script. A GUI will appear asking you to choose between single image or batch processing.

## Usage

1. **Single Image Mode:**

   * Select an image.
   * Choose filters and adjust their intensity.
   * Apply changes and save the edited image.

2. **Batch Processing Mode:**

   * Select a folder containing images.
   * Choose filters and their intensities.
   * Process all images in the folder.

## Requirements

* MATLAB R2018a or later / Octave 6.2.0 or later

## License

This project is licensed under the MIT License. See the LICENSE file for details.
