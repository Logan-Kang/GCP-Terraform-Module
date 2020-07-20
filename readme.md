
# GCP Terraform Module

  

해당 Repository는 손쉽게 사용하기 위해 Terraform으로 Module화하여 공유하고자 한다.
  

## Prepares

  

필요한 사항은 다음과 같다 :

  

**GCP Service Account**

>  - Compute Engine Admin 또는 해당 권한을 포함하고 있는 Service Account

  

**Environment Variables**

기존에는 GOOGLE_APPLICATION_CREDENTIALS를 이용하여 전역변수처럼 선언하였지만, backend가 없는 경우 별도로 전역변수를 선언할 필요가 없으므로 var.credentials만 변수로 선언해준다.
> In Linux OS
>  - export TF_VAR_credentials=/path/to/service/account
>  - export TF_VAR_project=[YOUR_PROJECT_ID]

> In Windows OS(PowerShell)
>  - $env:TF_VAR_credentials=/path/to/service/account
>  - $env:TF_VAR_project=[YOUR_PROJECT_ID]




## 사용 방법
모듈 사용 방법은 다음과 같다.

해당 VM 모듈은 총 4개의 옵션으로 구성되어 있다.
> vm1 : vm with 1disk, external ip
> vm2 : vm with 1disk, no external ip
> vm3 : vm with 2disk, external ip
> vm4 : vm with 2disk, no external ip

여기에서 필요한 옵션을 선택하여 모듈을 수행하면 된다.
동일한 옵션 사용을 위해 `instance-count`로 개수를 조절한다.

```terraform module
module "vm1_1disk_extip" {
  source              = "../0.modules/gce-vm"
  module_enabled      = true
  public_ip           = true
  add_disk            = false
  instance-count      = 1
  project-id          = var.project
  instance-name       = "kcg-vm1"
  machine-type        = "n1-standard-2"
  instance-region     = "asia-northeast3"
  cpu-platform        = "Intel Skylake"
  network_tags        = ["internal","external"]
  subnet-name         = "default"
  image               = "centos-cloud/centos-7"
  disk-type           = "pd-standard"
  disk-size           = "20"
  labels_creator      = "taurus"
  labels_create-date  = "200720"
  labels_env          = "test"
  startup-script      = "${file("stackdriver-agent.sh")}"
  # this is null(garbage)
  disk-type2          = "pd-standard"  # data not applicable
  disk-size2          = "20"           # data not applicable
}
```
```
module "vm2_1disk_intip" {
  source              = "../0.modules/gce-vm"
  module_enabled      = true
  public_ip           = false
  add_disk            = false
  instance-count      = 1
  project-id          = var.project
  instance-name       = "kcg-vm2"
  machine-type        = "n1-standard-2"
  instance-region     = "asia-northeast3"
  cpu-platform        = "Intel Skylake"
  network_tags        = ["internal"]
  subnet-name         = "default"
  image           = "centos-cloud/centos-7"
  disk-type       = "pd-standard"
  disk-size       = "20"
  labels_creator  = "taurus"
  labels_create-date = "200720"
  labels_env      = "test"
  startup-script = "${file("stackdriver-agent.sh")}"
  # this is null(garbage)
  disk-type2         = "pd-standard"  # data not applicable
  disk-size2         = "20"           # data not applicable
}
```
```
module "vm3-2disk-extip" {
  source          = "../0.modules/gce-vm"
  module_enabled  = true
  public_ip       = true
  add_disk        = true
  instance-count  = 1
  project-id      = var.project
  instance-name   = "kcg-vm3"
  machine-type    = "n1-standard-1"
  instance-region = "asia-northeast3"
  cpu-platform    = "Intel Skylake"
  network_tags    = ["internal","external"]
  subnet-name     = "default"
  image           = "centos-cloud/centos-7"
  disk-type       = "pd-standard"
  disk-size       = "20"
  labels_creator  = "taurus"
  labels_create-date = "200720"
  labels_env      = "test"
  startup-script = "${file("stackdriver-agent.sh")}"
  # second disk
  disk-type2         = "pd-standard"
  disk-size2         = "20"
}
```
```
module "vm4-2disk-intip" {
  source          = "../0.modules/gce-vm"
  module_enabled  = true
  public_ip       = false
  add_disk        = true
  instance-count  = 1
  project-id      = var.project
  instance-name   = "kcg-vm4"
  machine-type    = "n1-standard-1"
  instance-region = "asia-northeast3"
  cpu-platform    = "Intel Skylake"
  network_tags    = ["internal"]
  subnet-name     = "default"
  image           = "centos-cloud/centos-7"
  disk-type       = "pd-standard"
  disk-size       = "20"
  labels_creator  = "taurus"
  labels_create-date = "200720"
  labels_env      = "test"
  startup-script  = "${file("stackdriver-agent.sh")}"
  # second disk
  disk-type2         = "pd-standard"
  disk-size2         = "20"
}
```
`module_enabled` 변수와 `add_disk`, `public_ip` 변수의 조합을 통해 디스크를 추가할지, 공인IP를 사용할지, 일반 VM을 생성할지 결정하였음.

_p.s. `vm1, vm2`에서 disk2를 작성하지만 반영되지 않는다._

## ETC
  
  이번 git commit 시에는 instance with external ip만 작성하였지만, 추후 instance internal도 포함시켜 upgrade 및 다른 GCP resource 또한 점차적으로 추가해 나갈 예정이다.
  어느 정도 추가 완료 시 구성도 또한 포함시킬 예정이다.

단 이후 추가 시 GCP를 할지 다른 클라우드를 할지는 미지수...
  

> Written with [StackEdit](https://stackedit.io/).
