s1 = imread('sphere1.ppm');
s2 = imread('sphere2.ppm');
lucas_kanade(s1, s2);

s1 = imread('synth1.pgm');
s2 = imread('synth2.pgm');
lucas_kanade(s1, s2);
