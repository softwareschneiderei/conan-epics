@Library('ecdc-pipeline')
import ecdcpipeline.ContainerBuildNode
import ecdcpipeline.ConanPackageBuilder

project = "conan-epics"

conan_remote = "ess-dmsc-local"
conan_user = "ess-dmsc"
conan_pkg_channel = "stable"

containerBuildNodes = [
  'centos': ContainerBuildNode.getDefaultContainerBuildNode('centos7'),
  'debian': ContainerBuildNode.getDefaultContainerBuildNode('debian9'),
  'ubuntu': ContainerBuildNode.getDefaultContainerBuildNode('ubuntu1804')
]

packageBuilder = new ConanPackageBuilder(this, containerBuildNodes, conan_pkg_channel)
packageBuilder.defineRemoteUploadNode('centos')

builders = packageBuilder.createPackageBuilders { container ->
  packageBuilder.addConfiguration(container)
}

node {
  checkout scm

  builders['macOS'] = get_macos_pipeline()
  builders['windows10'] = get_win10_pipeline()

  parallel builders

  // Delete workspace when build is done.
  cleanWs()
}

if (conan_pkg_channel == "stable") {
  if (env.BRANCH_NAME != "master") {
    error("Only the master branch can create a package for the stable channel")
  }
  conan_upload_flag = "--no-overwrite"
} else {
  conan_upload_flag = ""
}

def get_macos_pipeline() {
  return {
    node('macos') {
      cleanWs()
      dir("${project}") {
        stage("macOS: Checkout") {
          checkout scm
        }  // stage

        stage("macOS: Conan setup") {
          withCredentials([
            string(
              credentialsId: 'local-conan-server-password',
              variable: 'CONAN_PASSWORD'
            )
          ]) {
            sh "conan user \
              --password '${CONAN_PASSWORD}' \
              --remote ${conan_remote} \
              ${conan_user} \
              > /dev/null"
          }  // withCredentials
        }  // stage

        stage("macOS: Package") {
          sh "conan create . ${conan_user}/${conan_pkg_channel} \
            --build=outdated"
        }  // stage

        if (conan_pkg_channel == "stable" && env.BRANCH_NAME == "master") {
          stage("macOS: Upload") {
            sh "upload_conan_package.sh conanfile.py \
              ${conan_remote} \
              ${conan_user} \
              ${conan_pkg_channel}"
          }  // stage
        }  // if
      }  // dir
    }  // node
  }  // return
}  // def

def get_win10_pipeline() {
  return {
    node ("windows10") {
      // Use custom location to avoid Win32 path length issues
    ws('c:\\jenkins\\') {
      cleanWs()
      dir("${project}") {
        stage("windows10: Checkout") {
          checkout scm
        }  // stage

        stage("windows10: Conan setup") {
          withCredentials([
            string(
              credentialsId: 'local-conan-server-password',
              variable: 'CONAN_PASSWORD'
            )
          ]) {
            bat """conan user \
              --password ${CONAN_PASSWORD} \
              --remote ${conan_remote} \
              ${conan_user}"""
          }  // withCredentials
        }  // stage

        stage("windows10: Package") {
          bat """conan create . ${conan_user}/${conan_pkg_channel} \
            --build=outdated"""
        }  // stage

        // stage("windows10: Upload") {
        //   sh "upload_conan_package.sh conanfile.py \
        //     ${conan_remote} \
        //     ${conan_user} \
        //     ${conan_pkg_channel}"
        // }  // stage
      }  // dir
      }
    }  // node
  }  // return
}  // def
