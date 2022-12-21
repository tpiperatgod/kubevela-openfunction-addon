package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				type: "k8s-objects"
				name: "openfunction-ns"
				properties: objects: [{
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: parameter.namespace
					//				}, {
					//					apiVersion: "v1"
					//					kind:       "Namespace"
					//					metadata: name: "ofn-knative-serving"
					//				}, {
					//					apiVersion: "v1"
					//					kind:       "Namespace"
					//					metadata: name: "ofn-contour"
				}, {
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: parameter.daprNamespace
				}, {
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: parameter.tektonNamespace
				}, {
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: parameter.shipwrightNamespace
				}, {
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: parameter.kedaNamespace
				}]
			},
			{
				name: "openfunction"
				type: "helm"
				dependsOn: ["openfunction-ns"]
				type: "helm"
				properties: {
					repoType:        "git"
					url:             "https://github.com/tpiperatgod/ofn-charts"
					chart:           "./openfunction"
					targetNamespace: parameter.namespace
					releaseName:     "openfunction"
					git:
						branch: "dev"
					values: {
						global: {
							Dapr: enabled:            false
							Keda: enabled:            false
							KnativeServing: enabled:  false
							TektonPipelines: enabled: false
							ShipwrightBuild: enabled: false
							Contour: enabled:         false
						}
					}
				}
			}, {
				name: "dapr"
				type: "helm"
				dependsOn: ["openfunction-ns"]
				type: "helm"
				properties: {
					repoType:        "helm"
					url:             "https://dapr.github.io/helm-charts/"
					chart:           "dapr"
					targetNamespace: parameter.daprNamespace
					releaseName:     "dapr"
					version:         "1.8.3"
				}
			}, {
				name: "keda"
				type: "helm"
				dependsOn: ["openfunction-ns"]
				type: "helm"
				properties: {
					repoType:        "helm"
					url:             "https://kedacore.github.io/charts"
					chart:           "keda"
					targetNamespace: parameter.kedaNamespace
					releaseName:     "keda"
					version:         "2.8.2"
				}
				//			}, {
				//				name: "contour"
				//				type: "helm"
				//				dependsOn: ["openfunction-ns"]
				//				type: "helm"
				//				properties: {
				//					repoType:        "helm"
				//					url:             "https://charts.bitnami.com/bitnami"
				//					chart:           "contour"
				//					targetNamespace: "ofn-contour"
				//					releaseName:     "contour"
				//					version:         "8.0.4"
				//				}
				//			}, {
				//				name: "knative-serving"
				//				type: "helm"
				//				dependsOn: ["openfunction-ns"]
				//				type: "helm"
				//				properties: {
				//					repoType:        "git"
				//					url:             "https://github.com/tpiperatgod/ofn-charts"
				//					chart:           "./knative-serving"
				//					targetNamespace: "ofn-knative-serving"
				//					releaseName:     "knative-serving"
				//					git:
				//						branch: "dev"
				//				}
			}, {
				name: "shipwright-build"
				type: "helm"
				dependsOn: ["openfunction-ns"]
				type: "helm"
				properties: {
					repoType:        "git"
					url:             "https://github.com/tpiperatgod/ofn-charts"
					chart:           "./shipwright-build"
					targetNamespace: parameter.shipwrightNamespace
					releaseName:     "shipwright-build"
					git:
						branch: "dev"
				}
			}, {
				name: "tekton-pipelines"
				type: "helm"
				dependsOn: ["openfunction-ns"]
				type: "helm"
				properties: {
					repoType:        "git"
					url:             "https://github.com/tpiperatgod/ofn-charts"
					chart:           "./tekton-pipelines"
					targetNamespace: "ofn-tekton"
					releaseName:     "tekton-pipelines"
					git:
						branch: "dev"
				}
			},
		]
		policies: [
			{
				name: "garbage-collect"
				type: "garbage-collect"
				properties: {
					rule: [{
						selector: {
							componentNames: ["openfunction-ns"]
						}
						strategy: "onAppDelete"
					}]
				}
			},
		]
	}
}
