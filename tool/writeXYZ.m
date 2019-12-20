function writeXYZ(X, filename)
  dlmwrite(filename,X,'delimiter',' ','precision','%.12f')
end