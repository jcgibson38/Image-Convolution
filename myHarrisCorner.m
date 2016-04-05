function [R] = myHarrisCorner(Ix,Iy,threshold)

  k = 0.04;

  # Determine pieces of M matrix #
  ixx = Ix.*Ix;
  iyy = Iy.*Iy;
  ixy = Ix.*Iy;

  printf("\nsmoothing Ixx, Ixy, and Iyy.")
  fflush(stdout);

  # Apply some more smoothing #
  h = fspecial('gaussian',[3 3],0.5);
  [imrows,imcols,imdims] = size(ixx);
  ix2 = zeros(imrows,imcols,imdims);
  iy2 = zeros(imrows,imcols,imdims);
  ixy2 = zeros(imrows,imcols,imdims);
  for i = 1:imdims
    ix2(:,:,i) = conv2(ixx(:,:,i),h,"same");
    iy2(:,:,i) = conv2(iyy(:,:,i),h,"same");
    ixy2(:,:,i) = conv2(ixy(:,:,i),h,"same");
  endfor

  printf("\ncalculating R.")
  fflush(stdout);

  R = zeros(imrows,imcols,imdims);

  # Loop throught the image and calculate R values #
  for i = 1:imrows
    for j = 1:imcols
      for k = 1:imdims
        M = [ix2(i,j,k),ixy2(i,j,k);ixy2(i,j,k),iy2(i,j,k)];
        dm = det(M);
        tm = trace(M);
        R(i,j,k) = dm - k*(tm**2);
      endfor
    endfor
    if mod(i,100) == 0
      printf("...")
      fflush(stdout);
    endif
  endfor

endfunction
