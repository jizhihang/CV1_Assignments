function [rankings, accuracies, map] = test_svms(test_h, test_l, test_files,... 
svm_airplane, svm_cars, svm_faces, svm_motorbikes)

[rk_airplane, ap_airplane] = predict_class(1, test_h, test_l, test_files, svm_airplane);
[rk_cars, ap_cars] = predict_class(1, test_h, test_l, test_files, svm_cars);
[rk_faces, ap_faces] = predict_class(1, test_h, test_l, test_files, svm_faces);
[rk_motorbikes, ap_motorbikes] = predict_class(1, test_h, test_l, test_files, svm_motorbikes);

rankings = {rk_airplane, rk_cars, rk_faces, rk_motorbikes};
accuracies = [ap_airplane, ap_cars, ap_faces, ap_motorbikes];

map = sum(accuracies) / 4;
end

function [ranking, ap] = predict_class(class, test_h, labels, test_files, svm)

% Construct ranking with true_labels | scores | file_indexes
ranking = zeros(length(labels), 3);
ranking(:,1) = labels == class;
ranking(:,3) = 1:length(test_files);

% Compute predictions
[~, scores] = predict(svm, test_h);
ranking(:,2) = scores(:,2);

% Sort by score from predictions, descending.
ranking = flipud(sortrows(ranking,2));

% Compute average precision
ap = 1 / sum(ranking(:,1)) * sum(ranking(:,1) .* cumsum(ranking(:,1)) ./ ranking(:,3));

end