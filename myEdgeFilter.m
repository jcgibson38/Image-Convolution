function [Im Ix Iy] = myEdgeFilter(img,sigma)

  printf("\nsmoothing.")
  fflush(stdout);

  # Pre-smoothing with gaussian filter #
  h = fspecial('gaussian',[3 3], sigma);
  img1 = myImageFilter(img,h);

  printf("\nx gradient pass.")
  fflush(stdout);

  # X-gradient convolution #
  Gx = [-1,0,1;-2,0,2;-1,0,1];
  Ix = myImageFilter(img1,Gx);

  printf("\ny gradient pass.")
  fflush(stdout);

  # Y-gradient convolution #
  Gy = [1,2,1;0,0,0;-1,-2,-1];
  Iy = myImageFilter(img1,Gy);

  printf("\nreducing edges Ix and Iy.")
  fflush(stdout);

  # Minimize edges to 1 pixel #
  [imrows,imcols,imdims] = size(Ix);
  for i = 3:imrows-2
    for j = 3:imcols-2
      for k = 1:imdims
        valy = Iy(i,j,k);
        if (Iy(i-1,j,k) > valy) || (Iy(i+1,j,k) > valy) || (Iy(i-2,j,k) > valy) || (Iy(i+2,j,k) > valy)
          Iy(i,j,k) = 0;
        endif
        valx = Ix(i,j,k);
        if (Ix(i,j-2,k) > valx) || (Ix(i,j+2,k) > valx) || (Ix(i,j-1,k) > valx) || (Ix(i,j+1,k) > valx)
          Ix(i,j,k) = 0;
        endif
      endfor
    endfor
    if mod(i,100) == 0
      printf("...")
      fflush(stdout);
    endif
  endfor

  printf("\ncombining gradients.")
  fflush(stdout);

  # Combine the gradients #
  Im = Ix+Iy;

  printf("\nreducing edges Im.")
  fflush(stdout);

  # Minimize edges to 1 pixel #
  [imrows,imcols,imdims] = size(Im);
  for i = 3:imrows-2
    for j = 3:imcols-2
      for k = 1:imdims
        val = Im(i,j,k);
        if (Im(i-1,j,k) > val) || (Im(i+1,j,k) > val) || (Im(i-2,j,k) > val) || (Im(i+2,j,k) > val)
          Im(i,j,k) = 0;
        endif
        if (Im(i,j-2,k) > val) || (Im(i,j+2,k) > val) || (Im(i,j-1,k) > val) || (Im(i,j+1,k) > val)
          Im(i,j,k) = 0;
        endif
      endfor
    endfor
    if mod(i,100) == 0
      printf("...")
      fflush(stdout);
    endif
  endfor

endfunction
