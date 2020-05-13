function best_match = compute_best_match(target_value, source)
   [y, ~] = size(source);
   enlarged_target = repmat(target_value, y, 1);
   square_diff = (enlarged_target - source).^2;

   weighted_sum = 0.5 * square_diff(:, 1) + 0.5 * square_diff(:, 2);
   [~, best_match] = min(weighted_sum);
end