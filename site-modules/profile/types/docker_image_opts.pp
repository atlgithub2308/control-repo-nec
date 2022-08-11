# Type alias for docker::image options
type Profile::Docker_image_opts = Struct[
  {
    ensure                 => Enum['present', 'absent', 'latest'],
    image                  => Pattern[/^[\S]*$/],
    Optional[image_tag]    => String,
    Optional[image_digest] => String,
    Optional[docker_tar]   => String,
    Optional[docker_dir]   => String,
  }
]
