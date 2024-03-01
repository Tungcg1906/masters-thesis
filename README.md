# Neural connectivity: a parallel in silico and in vitro analysis

## Abtract
In this thesis, we will analyze neuronal recordings obtained by multi-electrode arrays (MEAs) on in vitro neuronal cultures from prof. Vassanelli's laboratory, trying to estimate synaptic connectivity between the neurons. To this aim, we will adopt several time series analysis techniques, including transfer entropy and coincidence analysis. We will develop a simple in silico dynamical model of the biological neuronal network, building on the standard Izhikevich model and adding some realistic constraints on the network topology. The model will be use to simulate neuronal time series and validate the connectivity inference methods. The end goal of the project is being able to reliably estimate how synaptic connectivity spontaneously varies in time.

## Methods

FC|     TE and NSC             |  Null models
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/fc.png) | ![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/TE.png) |  ![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/null_model.png)

### 1. Functional connectivity
This connectivity metric we consider is just the standard Pearson correlation of the smoothed time series, which in neuroscience is commonly referred to as “functional connectivity”. To this aim, we first applied a Gaussian filter to the spike time series and then computed the Pearson correlation. We tried two different values of the filter width (10 ms and 100 ms respectively).

### 2. Transfer entropy
Connectivity metric analyzed is transfer entropy (TE). TE yields insights into how much information from one neuron’s activity can influence the activity of another neuron. We first computed TE values with delays from 1 to 20, and then kept a unique TE value corresponding to the maximum TE across delays. Raw TE values were later subjected to a null model testing at the level of each connection to identify significant links.

### 3. Number spike coincidences
The number of spiking coincidences (NSC) within the same window or within two successive windows (delay 0 and delay 1, respectively).

## Results
### 1. Silico analysis
#### 1.1. Non-bursty simulated data

Network TE|     Network NSC             |  Connectivity vs Ground truth
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/silico-net-1.png) | ![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/silico-net-2.png) |![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/non-bursty.png)

We tested three metrics (transfer entropy, TE; number of spiking coincidences, NSC; Gaussian filter functional connectivity, FC) in their ability to reconstruct the true connectivity structure of the network. For NSC we used two values of delay (0 delay and one window of delay, corresponding to a delay of 10 ms). For FC; we used two values for the filter standard deviations (σ = 10ms and σ = 100ms).
TE, normalized NSC and FC all achieved some degree of success in reconstruct- ing the network. However, the methods’ performances highly depend on the type of connection. TE and FC assign strong links to some of the spurious II connections. This problem is minimized by NSC (upon normalization), especially at delay 1. EE connections are well detected by all methods (very well by normalized NSC). IE connections are identified by all methods, but FC and TE are not able to spot the inhibitory nature of these connections. Only normalized NSC at delay 1 can, to a fair extent, identify this feature. Finally, all methods identify EI connections, although not as well as EE connections.
Overall, the best method among those tested is normalized NSC with delay.


#### 1.2. Bursty simulated data

Network TE|     Network NSC             |  Connectivity vs Ground truth
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/silico-net-3.png) | ![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/silico-net-4.png) |![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/bursty.png)

Similar to the analysis of the simulated non-bursty spike scenario, we conducted an assessment of three metrics (transfer entropy, TE; number of spiking coincidences, NSC; Gaussian filter functional connectivity, FC) with the aim of gauging their efficacy in reconstructing the true network connectivity structure.

Compared to the non-bursty scenario, connectivity reconstruction is generally less effective. In particular, it is much more difficult to eliminate spurious co- incidences and identify inhibitory connections. The effectiveness of the used metrics greatly hinges on the nature of the specific connection type. TE and FC attribute notable links to certain erroneous II connections. This issue is mitigated to a certain extent by NSC, especially when normalized, particularly at delay 1. EE connections are robustly identified by all methods, with normalized NSC excelling in this regard. IE connections are detectable by all methods, but no method is able to discern the inhibitory characteristic of these connections. In the case of EI connections, all methods identify them, although not as effectively as they do with EE connections.


### 2. Vitro analysis

Vitro network |     Heatmap  
:-------------------------:|:-------------------------:
![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/vitro-net.png) | ![](https://github.com/Tungcg1906/masters-thesis/blob/main/Images/vitro.png)

The investigation of culture neurons extended to using TE analysis and null mod- els, together with NSC and its null models. The absence of null models high- lighted the challenge of distinguishing meaningful patterns from random noise, impacting the interpretation of spike time behaviors. To address this, the study emphasized the importance of employing null models for accurate conclusions and reliable pattern detection. Null models provided a statistical foundation for model validation, enhancing the credibility of findings. Additionally, Gaussian filter analysis was applied to the culture dataset to understand neuronal plastic- ity. Gaussian filtering with different sigma values (10 and 100) was performed, resulting in smoothed spike distributions. The effect of sigma 100 was more pro- nounced, revealing more active data points beyond the diagonal in a generated heat map compared to sigma 10.
