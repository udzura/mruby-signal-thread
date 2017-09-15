MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem mgem: 'mruby-sleep'
  conf.gem mgem: 'mruby-process'
  conf.gem github: 'udzura/mruby-thread', branch: 'after-1.3'
  conf.linker.libraries << ['pthread']
  conf.gem File.expand_path(File.dirname(__FILE__))
  conf.cc.flags << "-DMRB_THREAD_COPY_VALUES"
  conf.enable_test
end
