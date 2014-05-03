Pod::Spec.new do |s|
  s.name         = "ISAlternativeRefreshControl"
  s.version      = "2.0"
  s.platform     = :ios, '5.0'
  s.summary      = "Replacement UIRefreshControl that doesn't directly depend on UIScrollView"
  s.homepage     = "https://github.com/RobotsAndPencils/ISAlternativeRefreshControl"
  s.author       = { "Yosuke Ishikawa" => "y@ishkawa.org", "Michael Beauregard" => "michael.beauregard@robotsandpencils.com" }
  s.source       = { :git => "https://github.com/RobotsAndPencils/ISAlternativeRefreshControl.git", :tag => "2.0" }
  s.source_files = ['ISAlternativeRefreshControl/*.{h,m}', 'DemoApp/IS*RefreshControl.{h,m}', 'DemoApp/IS*View.{h,m}', 'DemoApp/ISScalingActivityIndicatorView.{h,m}']
  s.resources    = ['DemoApp/arrow*.png', 'DemoApp/ISRefreshControlIcon*.png']
  s.framework    = 'QuartzCore'
  s.requires_arc = true
  s.license      = {
	:type => 'MIT',
	:text => <<-LICENSE
      Copyright (c) 2013 Yosuke Ishikawa

      Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

      The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	LICENSE
  }
end