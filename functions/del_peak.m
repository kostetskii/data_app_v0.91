crvlen = 128;

for i = 1:crvlen
    curr_crv_indx = find(csv_sorted(:,2) == i);
    curr_y_data = csv_sorted(curr_crv_indx,7);
    [~, indx_out] = max(diff(curr_y_data));
    indx_out = curr_crv_indx(indx_out+1);
    csv_sorted(indx_out,:) = [];
    fprintf('> %d of %d\n', i, crvlen);
end