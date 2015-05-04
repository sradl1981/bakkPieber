set multiplot layout 1,2        # engage multiplot mode
plot 'postProcessing/fluid/pressureDrop/0/faceSource.dat' u 1:3 w l
plot 'postProcessing/fluid/Tf_out/0/faceSource.dat' u 1:3 w l
pause 2
reread
