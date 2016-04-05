function [img1] = myImageFilter(img0,h)

  ### Pre-Process ###
  # Get the sizes of the image and the kernel #
  [imrows,imcols,imdims] = size(img0);
  [hrows,hcols] = size(h);

  # Determine the number of rows to add to the image #
  numrows = floor(hrows/2);
  numcols = floor(hcols/2);

  # First pad rows of the image as necessary #
  firstrow = img0(1,1:end,1:end);
  lastrow = img0(end,1:end,1:end);
  for i = 1:numrows
    img0 = [firstrow;img0];
    img0 = [img0;lastrow];
  endfor

  # Then pad cols of the image as necessary #
  firstcol = img0(1:end,1,1:end);
  lastcol = img0(1:end,end,1:end);
  for i = 1:numcols
    img0 = [firstcol,img0];
    img0 = [img0,lastcol];
  endfor

  # Get the size of the kernel #
  hsum = sum( h(:) );
  if hsum == 0
    hsum = 1;
  endif

  ### Convolution ###
  img1 = zeros(imrows,imcols,imdims);

  # Loop through the whole image #
  for i = 1+numrows:imrows
    for j = 1+numcols:imcols
      for k = 1:imdims
        # We need to increase storage size of elements for applying the kernel #
        tempm = int16(img0(i-numrows:i+numrows,j-numcols:j+numcols,k)) .* h;
        newval = sum( tempm(:) )/hsum;
        if newval < 0
          newval = 0;
        elseif newval > 255
          newval = 255;
        endif
        # Assign the new value to the corresponding index in the output image #
        img1(i-numrows,j-numrows,k) = newval;
      endfor
    endfor
    if mod(i,100) == 0
      printf("...")
      fflush(stdout);
    endif
  endfor

  imwrite(uint8(img1),"img01_edge_1.png");

endfunction
