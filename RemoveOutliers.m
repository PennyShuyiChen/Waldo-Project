function [ cleaned_data ] = RemoveOutliers(data)
%Takes in a vertical vector "data" and removes any entries that are above
%or below three standard deviations from the mean.

cleaned_data = data;
mean_data = mean(data);
standardDev = std(data);

for ii = 1:length(data)
    if data(ii) >= (mean_data + (3*standardDev))
%         disp('too big')
        cleaned_data(ii) = NaN;
    elseif data(ii) <= (mean_data - (3*standardDev))
%         disp('too small')
        cleaned_data(ii) = Nan;
    else
%         disp('fine')
    end
end

values = isnan(cleaned_data);
indicies2delete = find(values == 1);

cleaned_data(indicies2delete) = [];





