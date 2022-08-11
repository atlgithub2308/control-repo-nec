# Profile for setting up docker
class profile::docker (
  Array[Profile::Docker_image_opts] $images = [],
) {
  include 'docker'

  $images.each |$opts| {
    docker::image { "Profile docker - Docker image ${opts['image']} is ${opts['ensure']}":
      ensure       => $opts['ensure'],
      image        => $opts['image'],
      image_tag    => $opts.dig('image_tag'),
      image_digest => $opts.dig('image_digest'),
      docker_tar   => $opts.dig('docker_tar'),
      docker_dir   => $opts.dig('docker_dir'),
    }
  }
}
