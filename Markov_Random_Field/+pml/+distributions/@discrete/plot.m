function [] = plot(this, varargin)
  if (this.ndims > 1), error('NDIMS > 1 not supported.'), end
  
  plot(this.domain_grid{1}, this.weights, varargin{:});
end