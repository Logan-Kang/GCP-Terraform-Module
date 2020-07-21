
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




## 사용 방법-vm
모듈 사용 방법은 다음과 같다.

해당 VM 모듈은 총 4개의 옵션으로 구성되어 있다.
>  - vm1 : vm with 1disk, external ip
>  - vm2 : vm with 1disk, no external ip
>  - vm3 : vm with 2disk, external ip
>  - vm4 : vm with 2disk, no external ip

여기에서 필요한 옵션을 선택하여 모듈을 수행하면 된다.
동일한 옵션 사용을 위해 `instance-count`로 개수를 조절한다.

```terraform module
(예시)
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

`module_enabled` 변수와 `add_disk`, `public_ip` 변수의 조합을 통해 디스크를 추가할지, 공인IP를 사용할지, 일반 VM을 생성할지 결정하였음.

_p.s. `vm1, vm2`에서 disk2를 작성하지만 반영되지 않는다._

## 사용 방법-vpc
모듈 사용 방법은 다음과 같다.

```terraform module
(예시)
module "vpc" {
  source       = "../0.modules/default-vpc"
  project_id   = var.project
  network_name = "korea-host-test"

  subnets = [
    {
      subnet_name   = "s-an3-1"
      subnet_ip     = "10.0.0.0/18"
      subnet_region = "asia-northeast3"
    },
    {
      subnet_name   = "s-an3-2"
      subnet_ip     = "10.0.64.0/18"
      subnet_region = "asia-northeast3"
    },
    {
      subnet_name   = "s-an3-3"
      subnet_ip     = "10.0.128.0/18"
      subnet_region = "asia-northeast3"
    },
  ]
}

resource "google_compute_firewall" "fi-allow-internal" {
  depends_on = [module.vpc]
  name    = "fi-allow-internal"
  network = "korea-host-test"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["10.0.0.0/16"]
}
```
VPC network의 이름을 설정한 뒤, 해당 VPC에 들어가는 subnet에 대하여 custom으로 이름, IP, region을 입력해준다. 

그 이후에 추가적으로 internal 리소스들에 대해서 firewall를 추가적으로 입력하는 resource를 생성하였다.
(이외에 외부에서 접근하는 ssh, rdp, icmp는 모듈 내부에 작성하였음.)

_p.s. allow_internal 방화벽 관련하여 모듈 내부에 넣는 방법을 아는 사람은 연락해주거나, issue 등록 등으로 업데이트 방법을 알려주었으면 좋겠다._

## ETC
  
  이번 git commit 시에는 instance with external ip만 작성하였지만, 추후 instance internal도 포함시켜 upgrade 및 다른 GCP resource 또한 점차적으로 추가해 나갈 예정이다.
  어느 정도 추가 완료 시 구성도 또한 포함시킬 예정이다.

단 이후 추가 시 GCP를 할지 다른 클라우드를 할지는 미지수...
  

> Written with [StackEdit](https://stackedit.io/).
