# film-thickness
>The total-internal reflectance technique of measuring film thickness was detailed in Hurlburt and Newell (1996).  When a point of light passes through a transparent barrier and disperses into a film, all light beyond the critical angle of the film-boundary interface will be reflected back down towards the barrier.  With a translucent medium (Figure 1) affixed to the barrier, the film thickness may be calculated by analyzing the light ring projected onto the medium by the reflected light.  The diameter of this light ring corresponds to the thickness of the film at the point of reflection. ***Simon Livingston-Jha***

## Documentation
### Git and MATLAB

Git is a powerful source control program. To learn more about the integration of Git in MATLAB and how it is beneficial, visit [this Site](http://www.mathworks.com/help/matlab/matlab_prog/set-up-git-source-control.html).

### How-to


1. Find pixel size using MeasureObject.m and image of calibration target.
2. Process dry images (use around 100 images) using OpenTiffTry. Record mean diameter and standard error (although the error calculation does not seem very good)
3. Process actual images using FilmThicknessCalc_parallel.m. Change values for pixel size and dry image diameter and error before running.
4. Plot results with FilmThicknessAnalysis1a.
