    pipeline {

        tools {
            maven 'mymaven'
        }

        agent any

        environment {
            GOOGLE_APPLICATION_CREDENTIALS = '/var/lib/jenkins/gcp-key.json'
            PROJECT_ID = 'cellular-tide-420012'
            CLUSTER_NAME = 'kube-clusters'
            REGION = 'us-central1-c'
            DOCKER_REGISTRY = 'https://index.docker.io/v1/'
            DOCKER_IMAGE = 'reshmastani382/abcimage'
            KUBECONFIG = '/var/lib/jenkins/kubeconfig.yaml'

        }

        stages {
            stage('Checkout') {
                steps {
                    // Checkout the code from the repository
                    git branch: 'main', url: ' https://github.com/reshma-stani/pg_project.git '
                }
            }

            stage('Compile') {
                steps {
                    // Compile the Maven project
                    sh 'mvn compile'
                }
            }
            stage('Test') {
                steps {
                    // Run Maven tests
                    sh 'mvn test'
                }
            }
            stage('Package') {
                steps {
                    // Clean and package the Maven project
                    sh 'mvn clean package'
                }
            }


            stage('Build Image') {
                steps {

                    // Copy the WAR file to the webapps directory in the container
                    // sh 'cp /var/lib/jenkins/workspace/Industry_project/target/ABCtechnologies-1.0.war abc_tech.war'
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                }
            }
            stage('Push DockerImage') {
                steps {
                    // withDockerRegistery([ credentialsId: "dockerhub", url: ""])
                    withDockerRegistry(credentialsId: 'f80a6223-95e8-4a88-a9af-362d5c4a129c', url: DOCKER_REGISTRY) {
                        sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    }
                }
            }



            stage('Run Docker Container') {
                steps {
                    script {
                        //Below removed to test the container status 
                        // docker.image("${DOCKER_IMAGE}:${BUILD_NUMBER}").run("-p 8079:8080") 

                        def dockerImage = "${DOCKER_IMAGE}:${BUILD_NUMBER}"

                        //Changing below due to #92
                        def container = docker.image(dockerImage).run("-d")
                        def containerId = container.id

                        // Additional setup commands to run inside the Docker container
                       // try {
                            // Run commands inside the Docker container
                            sh "docker exec $containerId ls -la"
                            sh "docker exec $containerId echo 'Docker container is running'"

                       // } finally {
                            // Cleanup: Stop and remove the container after execution
                           // sh "docker stop $containerId"
                           // sh "docker rm $containerId"
                      //  }
                    }
                }
            }

            stage('GKE Cluster creation') {
                steps {
                    script {
                        //Check if Cluster exists

                        def clusterExists = sh (script: "gcloud container clusters describe ${CLUSTER_NAME}  --project ${project_ID} --zone ${REGION}", returnStatus: true ) == 0

                        if (!clusterExists){
                                //run only if cluster is absent
                                sh "gcloud container clusters create ${CLUSTER_NAME} --project ${PROJECT_ID} --zone ${REGION} --num-nodes 3 --no-enable-ip-alias"
                                echo "Cluster ${CLUSTER_NAME} creation Success "
                        }
                        else{
                             echo "Cluster ${CLUSTER_NAME} already exist, skipping creation." 
                        }
                    }
                }
            }

            /*stage('Expose GKE Cluster') {
                steps {
                    sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --project ${PROJECT_ID} --zone ${REGION}"
                    sh "kubectl expose deployment my-container-deployment --type=LoadBalancer --port=80 --target-port=8079 --name=my-container-service"
                }
            } */

            /* stage('Deploy Artifacts on Kubernetes') {
               steps {
                    script {
             Apply Kubernetes manifests
              sh "kubectl apply -f pod.yaml"
               sh "kubectl apply -f service.yaml"
               sh "kubectl apply -f deployment.yaml"
                    }
            //     }
             } 
             */
            stage('Run Ansible Playbook') {
                environment {
                    ANSIBLE_LOG_PATH = '/var/log/jenkins/ansible-playbook.log'
                }
                steps {
                    // Execute Ansible playbook
                    sh "ansible-playbook -v -e 'DOCKER_IMAGE=${DOCKER_IMAGE}' -e 'BUILD_NUMBER=${BUILD_NUMBER}' playbook.yml"

                }
            }
            // Assigning External IP 
            stage('Update Service with External IP') {
                steps {
                    script {
                        // Obtain external IP address from Load Balancer
                        def externalIP = sh( script: "gcloud compute forwarding-rules describe my-forwarding-rule --region ${REGION} --format='get(IPAddress)'", returnStdout: true).trim()


                    // Patch Kubernetes Service with external IP
                    sh "kubectl patch svc my-container-service -n ${CLUSTER_NAME} --type='json' -p '[{\"op\":\"replace\",\"path\":\"/spec/loadBalancerIP\",\"value\":\"${externalIP}\"}]'"

                }
            }    

         }

        }
    }
    
