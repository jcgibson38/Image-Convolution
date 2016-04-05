function lab3_demo(img)

  # threshold for lines #
  threshold = -90000000;

  # Apply edge filter #
  [Im,Ix,Iy] = myEdgeFilter(img,0.5);

  # Extract edges with Harris Corner algorithm #
  R = myHarrisCorner(Ix,Iy,threshold);

  printf("\n")
  fflush(stdout);

  # Plots #
  subplot(2,2,1);
  imshow(uint8(Ix));
  title("Ix");

  subplot(2,2,2);
  imshow(uint8(Iy));
  title("Iy");

  subplot(2,2,3);
  imshow(uint8(Im));
  title("Im");

  subplot(2,2,4);
  hold("on");
  imshow(uint8(img));
  [row,col] = find(R < threshold);
  plot(col,row,"r.");
  hold("off");
  title("img");

endfunction
