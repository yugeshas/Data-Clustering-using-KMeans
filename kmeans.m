%Initialize input data 
mu1 = [1 0];
mu2 = [0 1.5];
sigma1 = [0.9 0.4; 0.4 0.9];
sigma2 = [0.9 0.4; 0.4 0.9];
c = [10 10; -10 -10; 10 -10; -10 10];
k = 4;
n = 500;

%create Gaussian random data
data1 = builddataset(mu1,sigma1,n);
data2 = builddataset(mu2,sigma2,n);
data = [data1; data2];

%calculate clusters and centroid
clusters = mykmeans(data,k,c);

%calculates centroid till the l2-norm of old and new centroid is <= 0.001
function cluster = mykmeans(X,k,c)
iter = 0;
cluster = [];
l2norm = true;
while l2norm 
    iter = iter + 1;
    dist1 = caldistances(X, k, c);
    newclusters = assigncluster(dist1);
    centroid = calnewcentroid(newclusters,X);
    l2norm = checkl2norm(centroid,k,c);
    c = centroid;        
end
disp("No of iterations = "+iter);
cluster = [cluster, X];
cluster = [cluster, newclusters];
display(cluster,c);
end

%calculates distance between each data point with all present centroids
function dist = caldistances(X, k, c)
dist = [];
for i = 1:k
    distfromc = sqrt(sum((X - c(i,[1 2])).^ 2, 2));
    dist = [dist, distfromc];
end
end

%Creates Gaussian random data
function dataset = builddataset(mu,sigma,n)
%rng default  % For reproducibility
dataset = mvnrnd(mu,sigma,n);
end

%Assign cluster to data point based on its distance from each point. 
function clustdata = assigncluster(dist)
[~,clustdata] = min(dist,[],2);
end

%calculates new centroid with respect to each cluster 
function centroid = calnewcentroid(newclusters,data)
centroid = grpstats(data,newclusters);
end

%prints total no of iterations, final centroids and scatter plot. 
function display(cluster, centroids)
for i = 1:size(centroids)
    disp("c"+i+" = ");
    disp("x = "+centroids(i,1)+" y = "+centroids(i,2)); 
end   

gscatter(cluster(:,1),cluster(:,2),cluster(:,3),'','.',12)
hold on
gscatter(centroids(:,1),centroids(:,2),'','k','.',15)
title 'Cluster Assignments and Centroids';
hold off
end

%evaluates l2-norm between old and new centroids. 
function l2norm = checkl2norm(newcentroid,k,c)
for i = 1 : k
    l2normofc = sqrt(sum((c - newcentroid).^ 2, 2));
end
I = find(l2normofc < 0.001);
if length(I) == k
    l2norm = false;
else
    l2norm = true;
end
end
