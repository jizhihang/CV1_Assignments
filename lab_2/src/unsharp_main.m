i4 = imread('Images/image4.jpeg');
% First vary k
unsharp(i4, 10, 5, 1);
unsharp(i4, 10, 5, 10);
% Then vary sigma
unsharp(i4, 2, 5, 1);
unsharp(i4, 2, 5, 10);