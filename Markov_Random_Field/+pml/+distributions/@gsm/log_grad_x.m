function g = log_grad_x(this, x)
  
  ndims   = this.ndims;
  nscales = this.nscales;
  ndata   = size(x, 2);
  
  x_mu = bsxfun(@minus, x, this.mu);
  
  if (iscell(this.precision))
    norm_const = zeros(nscales, 1);
    maha       = zeros(nscales, ndata);
    for j = 1:nscales
      norm_const(j) = sqrt(det(this.precision{j})) / ((2 * pi) ^ (ndims / 2));
      maha(j, :) = sum(x_mu .* (this.precision{j} * x_mu), 1);
      P_x_mu{j} = this.precision{j} * x_mu;
    end
  else
    norm_const = sqrt(det(this.precision)) / ((2 * pi) ^ (ndims / 2));
    maha = sum(x_mu .* (this.precision * x_mu), 1);
    P_x_mu = this.precision * x_mu;
  end
  
  y = bsxfun(@times, norm_const .* this.weights(:) .* (this.scales(:) .^ (ndims/2)), ... 
      exp(bsxfun(@times, -0.5 * this.scales(:), maha)));
  y = bsxfun(@rdivide, y, sum(y, 1));
  
  g = zeros(ndims, ndata);
  for s = 1:nscales
    if (iscell(P_x_mu))
      g = g - this.scales(s) * bsxfun(@times, P_x_mu{s}, y(s, :));
    else
      g = g - this.scales(s) * bsxfun(@times, P_x_mu, y(s, :));
    end
  end
end
