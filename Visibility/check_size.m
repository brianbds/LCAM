function [coordinates]=check_size(coordinates, numRows, numCols)
checkArray = [coordinates(1,1)<1, coordinates(1,2)<1; coordinates(2,1)>numRows, coordinates(2,2)>numCols];
coordinates = checkArray.*[1, 1; numRows, numCols]+ (~checkArray).*coordinates;
end