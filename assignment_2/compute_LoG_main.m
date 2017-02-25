i1 = imread('Images/image1.jpeg');
r1 = compute_LoG(i1, 1);
r2 = compute_LoG(i1, 2);
r3 = compute_LoG(i1, 3);

subplot(2,2,1), imshow(i1, []), title('Initial image');
subplot(2,2,2), imshow(r1, []), title('LoG 1');
subplot(2,2,3), imshow(r2, []), title('LoG 2');
subplot(2,2,4), imshow(r3, []), title('LoG 3');