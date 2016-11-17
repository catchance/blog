{% extends '_layout.swig' %}
{% import '_macro/post.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %} {{ config.title }} {% endblock %}

{% block page_class %}
  {% if is_home() %} page-home {% endif %}
{% endblock %}

{% block content %}

<!--
  <section id="posts" class="posts-expand">
    {% for post in page.posts %}
      {{ post_template.render(post, true) }}
    {% endfor %}
  </section>

  {% include '_partials/pagination.swig' %}
-->
<div class="home">
<div class="banner">
    <div class="banner-text">
        <h1 class="headline">chance <span></span></h1>
        <h3>Talk is cheap,</h3>
        <h3>Show me the code...</h3>

        <ul class="social">
            <li><a href="https://github.com/catchance" target="_blank"><i class="fa fa-github"></i></a></li>
            <!--
            <li><a href="//www.facebook.com/catchance"><i class="fa fa-facebook"></i></a></li>
            <li><a href="https://twitter.com/catchance"><i class="fa fa-twitter"></i></a></li>
             -->
            <li><a href="http://linkedin.com/in/catchance" target="_blank"><i class="fa fa-linkedin"></i></a></li>
            <li><a href="http://weibo.com/xxchance" target="_blank"><i class="fa fa-weibo"></i></a></li>
            <li><a href="mailto:catchance@163.com"><i class="fa fa-envelope"></i></a></li>
        </ul>
    </div>
</div>
</div>
{% endblock %}

<!--
{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}
-->
