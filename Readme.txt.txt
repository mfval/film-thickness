1/ Find pixel size using MeasureObject.m and image of calibration target.
2/ Process dry images (use around 100 images) using OpenTiffTry. Record mean diameter and standard error (although the error calculation does not seem very good)
3/ Process actual images using FilmThicknessCalc_parallel.m. Change values for pixel size and dry image diameter and error before running.
4/ Plot results with FilmThicknessAnalysis1a.